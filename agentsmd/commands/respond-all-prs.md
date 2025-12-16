---
description: Spawn parallel subagents to review and address feedback on all open PRs in the current repository
model: opus
author: JacobPEvans
allowed-tools: Task, TaskOutput, TodoWrite, Bash(gh:*), Bash(git:*), Read, Glob, Grep
---

# Respond to All PR Reviews

**Purpose**: Systematically address all pending review comments across all open PRs in the **current repository only**
by launching parallel subagents that create worktrees and respond to feedback.

## Scope

This command operates on the **current repository** (determined from git remote or cwd).
For cross-repository operations, use `/fix-all-pr-ci` instead.

## How It Works

You are the **orchestrator**. You will:

1. Identify the current repository from `gh repo view`
2. List all open PRs with `gh pr list`
3. Get review comments for each PR
4. Create worktrees for PRs with unresolved comments
5. Launch parallel subagents (Task tool) for each PR
6. Monitor completion with TaskOutput
7. Verify all comments are addressed
8. Clean up worktrees
9. Report final status

## Execution Steps

### Step 1: Identify Repository

```bash
# Get current repo info
gh repo view --json nameWithOwner --jq '.nameWithOwner'
```

### Step 2: List Open PRs

```bash
# Get all open PRs with review status
gh pr list --json number,headRefName,title,reviewDecision,reviews
```

### Step 3: Get Review Comments Per PR

For each PR, fetch unresolved review threads:

```bash
gh api graphql -f query='
query($owner: String!, $repo: String!, $pr: Int!) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $pr) {
      reviewThreads(first: 100) {
        nodes {
          id
          isResolved
          path
          line
          comments(first: 10) {
            nodes {
              id
              databaseId
              body
              author { login }
            }
          }
        }
      }
    }
  }
}' -f owner="OWNER" -f repo="REPO" -F pr=NUMBER
```

Filter for PRs with `isResolved: false` threads.

### Step 4: Create Worktrees

For each PR with unresolved comments:

```bash
# Create worktree for the PR branch
git worktree add ~/git/<repo-name>/<branch-name> <branch-name>
```

Worktree path convention: `~/git/<repo-name>/<branch-name>` (e.g., `~/git/my-repo/feat/issue-42-add-feature`)

### Step 5: Launch Parallel Subagents

Launch ONE subagent per PR in a SINGLE message with multiple Task tool calls.

**Subagent Prompt**:

```text
Respond to all review comments for PR #{NUMBER} in {OWNER}/{REPO}

Branch: {BRANCH_NAME}
Worktree: {WORKTREE_PATH}
Title: {PR_TITLE}

Unresolved comments:
{LIST_OF_COMMENTS_WITH_FILE_PATH_AND_LINE}

Your mission:
1. Navigate to the worktree: cd {WORKTREE_PATH}
2. For EACH unresolved comment:
   a. Read the file and understand context
   b. Analyze the feedback (is it valid? actionable?)
   c. If actionable: make the fix, commit with descriptive message
   d. If not actionable: prepare explanation why
3. Push changes: git push origin {BRANCH_NAME}
4. Reply to each comment on GitHub:
   - If fixed: "Fixed in commit {SHA}. {Brief explanation of change}"
   - If rejected: "Acknowledged. {Explanation of why not changing}"
5. Resolve threads via GraphQL mutation if you fixed the issue

CRITICAL RULES:
- Work ONLY in the provided worktree
- NEVER disable linters/tests/checks
- ALWAYS fix the actual issue when valid
- Use signed commits if configured
- Reply to EVERY comment (even if just acknowledging)

Report when complete:
✅ PR: https://github.com/{OWNER}/{REPO}/pull/{NUMBER}
✅ Comments addressed: {N}/{TOTAL}
✅ Commits made: {N}
⚠️ Rejected feedback: {list or "none"}
```

### Step 6: Monitor Subagents

Wait for all agents to complete using `TaskOutput` with `block=true`.

Verify each PR's review threads are resolved:

```bash
gh api graphql -f query='...' | jq '.data.repository.pullRequest.reviewThreads.nodes | map(select(.isResolved == false)) | length'
```

### Step 7: Clean Up Worktrees

After all subagents complete:

```bash
git worktree remove /path/to/worktree
```

### Step 8: Final Report

```text
## PR Review Response Results

Repository: {OWNER}/{REPO}
PRs processed: {N}

✅ FULLY ADDRESSED ({N} PRs):
- #{NUMBER}: {TITLE} - {N} comments resolved
...

⚠️ PARTIAL ({N} PRs):
- #{NUMBER}: {N}/{TOTAL} comments addressed, {N} rejected
...

❌ FAILED ({N} PRs):
- #{NUMBER}: {reason}
...

Worktrees cleaned up: {N}
```

## Parallel Execution Strategy

| Phase | Method | Parallelism |
| ----- | ------ | ----------- |
| 1-3. Discovery | Sequential Bash | 1 (prerequisite) |
| 4. Create worktrees | Parallel Bash | N (one per PR) |
| 5. Respond to reviews | Parallel Task agents | N (one per PR) |
| 7. Cleanup worktrees | Parallel Bash | N (one per PR) |

## Batching

If > 10 PRs need processing:

- Process first 10
- Wait for completion
- Process next batch
- Avoids overwhelming the system

## Error Handling

If subagent fails on a PR:

- Mark as "needs human review"
- Log the issue
- Continue with other PRs
- Don't let one failure block everything

## Key Differences from /fix-all-pr-ci

| Aspect | /respond-all-prs | /fix-all-pr-ci |
| ------ | ---------------- | -------------- |
| Scope | Current repo only | All owned repos |
| Focus | Review comments | CI failures |
| Worktrees | Uses worktrees | Clones to /tmp |
| GitHub API | GraphQL for threads | REST for checks |

## Example Usage

```bash
# From any worktree in the repo
/respond-all-prs
```

The orchestrator will:

1. Detect current repository
2. Find all open PRs with unresolved review comments
3. Create worktrees for each
4. Launch parallel subagents
5. Monitor and verify
6. Clean up and report

No user interaction needed - fully autonomous!

---

**Remember**: Current repo only, use worktrees, reply to ALL comments, clean up after.
