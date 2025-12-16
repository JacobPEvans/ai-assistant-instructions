---
description: Spawn parallel subagents to respond to PR reviews across all owned repositories
model: opus
author: JacobPEvans
allowed-tools: Task, TaskOutput, TodoWrite, Bash(gh:*), Read, Grep, Glob
---

# Respond to All PR Reviews (All Repos)

**Purpose**: Systematically address all pending review comments across all open PRs in **all owned repositories** by launching parallel subagents per repository.

## Scope

**ALL OWNED REPOSITORIES** - This command scans all repositories you own for open PRs with unresolved review comments.

What this command DOES:

- List all repositories using `gh repo list`
- Find repos with open PRs that have unresolved review threads
- Launch parallel subagents per REPOSITORY (each runs `/respond-all-prs` logic)
- Monitor completion across all repos
- Report aggregated results

What this command DOES NOT:

- Use worktrees directly (subagents handle that)
- Operate on a single repository only

For single-repo review response, use `/respond-all-prs` instead.

## Related Documentation

- [Subagent Parallelization](../rules/subagent-parallelization.md) - Parallel execution patterns

## How It Works

You are the **orchestrator**. You will:

1. List all repositories using `gh repo list`
2. For each repo, check for open PRs with unresolved review threads
3. Launch parallel subagents (Task tool) per REPOSITORY with review work
4. Monitor completion with TaskOutput
5. Aggregate results from all repos
6. Report final status

## Execution Steps

### Step 1: Discovery

```bash
# Get owner
OWNER=$(gh api user --jq .login)

# Get all repos
gh repo list "$OWNER" --limit 1000 --json name --jq '.[].name'
```

### Step 2: Find Repos with Review Work

For each repo, check for open PRs with unresolved review threads:

```bash
# Get open PRs for repo
gh pr list --repo "$OWNER/$REPO" --json number,headRefName,title
```

For each PR, check for unresolved threads:

```bash
gh api graphql -f query='
query($owner: String!, $repo: String!, $pr: Int!) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $pr) {
      reviewThreads(first: 100) {
        nodes {
          isResolved
        }
      }
    }
  }
}' -f owner="$OWNER" -f repo="$REPO" -F pr=$NUMBER
```

Filter repos that have at least one PR with unresolved threads.

### Step 3: Launch Parallel Subagents

Launch ONE subagent per REPOSITORY in a SINGLE message with multiple Task tool calls.

**Subagent Prompt**:

```text
Respond to all PR review comments in {OWNER}/{REPO}

Repository: {OWNER}/{REPO}
PRs with unresolved comments: {LIST_OF_PR_NUMBERS}

Your mission:
1. Clone or navigate to repo: gh repo clone {OWNER}/{REPO} /tmp/respond-{REPO}
2. For EACH PR with unresolved comments:
   a. Create worktree: git worktree add /tmp/respond-{REPO}/{BRANCH} {BRANCH}
   b. Fetch unresolved review threads via GraphQL
   c. For each thread:
      - Read the file and context
      - Analyze feedback (valid? actionable?)
      - If actionable: make fix, commit
      - If not: prepare explanation
   d. Push changes: git push origin {BRANCH}
   e. Reply to each comment on GitHub
   f. Resolve threads via GraphQL if fixed
3. Clean up worktrees when done

CRITICAL RULES:
- NEVER disable linters/tests/checks
- ALWAYS fix the actual issue when valid
- Reply to EVERY comment (even if just acknowledging)

Report when complete:
✅ Repository: {OWNER}/{REPO}
✅ PRs processed: {N}
✅ Comments addressed: {N}/{TOTAL}
⚠️ Rejected feedback: {list or "none"}
```

### Step 4: Monitor Subagents

Wait for all agents to complete using `TaskOutput` with `block=true` for each agent ID.

### Step 5: Final Report

```text
## Cross-Repo PR Review Response Results

Total repos scanned: {N}
Repos with work: {N}
Total PRs processed: {N}

✅ FULLY ADDRESSED ({N} repos):
- {OWNER}/{REPO}: {N} PRs, {N} comments resolved
...

⚠️ PARTIAL ({N} repos):
- {OWNER}/{REPO}: {N}/{TOTAL} comments addressed
...

❌ FAILED ({N} repos):
- {OWNER}/{REPO}: {reason}
...
```

## Key Differences from /respond-all-prs

| Aspect | /respond-all-prs | /respond-all-prs-all-repos |
| ------ | ---------------- | -------------------------- |
| Scope | Current repo only | All owned repos |
| Parallelism | Per PR | Per REPOSITORY |
| Subagent task | Handle one PR | Handle all PRs in one repo |

## Batching

If > 10 repos need processing:

- Process first 10
- Wait for completion
- Process next batch
- Avoids overwhelming the system

## Error Handling

If subagent fails on a repo:

- Mark repo as "needs human review"
- Log the issue
- Continue with other repos
- Don't let one failure block everything

## Example Usage

```bash
/respond-all-prs-all-repos
```

The orchestrator will:

1. Scan all owned repos
2. Find repos with open PRs that have unresolved reviews
3. Launch parallel subagents per repo
4. Monitor and aggregate
5. Report cross-repo results

---

**Remember**: All repos, one subagent per repo, aggregate results, handle failures gracefully.
