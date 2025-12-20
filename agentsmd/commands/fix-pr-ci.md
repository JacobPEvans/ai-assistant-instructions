---
description: Fix all CI failures across all open PRs in the current repository
model: opus
author: JacobPEvans
allowed-tools: Task, TaskOutput, TodoWrite, Bash(gh:*), Bash(git:*), Read, Grep, Glob
---

# Fix PR CI Failures

**Purpose**: Fix all CI failures across all open PRs in the **current repository only** by launching parallel subagents
that work autonomously until all PRs are mergeable.

## Scope

**CURRENT REPOSITORY ONLY** - This command operates on the repository you're currently in.

What this command DOES:

- List all open PRs in the current repository
- Find PRs with failing CI checks
- Create worktrees for each PR needing fixes
- Launch parallel subagents per PR
- Verify PRs are mergeable
- Clean up worktrees when done

What this command DOES NOT:

- Cross into other repositories
- Affect PRs in your other projects

For cross-repository CI fixes, use `/fix-all-pr-ci` instead.

## Related Documentation

- [Worktrees](../rules/worktrees.md) - Worktree structure and usage
- [Subagent Parallelization](../rules/subagent-parallelization.md) - Parallel execution patterns
- [Merge Conflict Resolution](../rules/merge-conflict-resolution.md) - How to resolve conflicts properly

## How It Works

You are the **orchestrator**. You will:

1. Identify the current repository from `gh repo view`
2. List all open PRs with `gh pr list`
3. Filter for PRs with failing CI checks
4. Create worktrees for each failing PR
5. Launch parallel subagents (Task tool) per PR
6. Monitor completion with TaskOutput
7. Verify PRs are mergeable
8. Clean up worktrees
9. Report final status

## Execution Steps

### Step 1: Identify Repository

```bash
# Get current repo info
gh repo view --json nameWithOwner --jq '.nameWithOwner'
```

### Step 2: List PRs with Failing CI

```bash
# Get all open PRs with CI status
gh pr list --json number,headRefName,title,statusCheckRollup,mergeable
```

Filter for PRs where:

- Any check has `conclusion: "FAILURE"`
- OR `mergeable != "MERGEABLE"`

### Step 3: Create Worktrees

For each PR with failing CI:

```bash
# Ensure branch is fetched
git fetch origin <branch-name>

# Create worktree for the PR branch
git worktree add ~/git/<repo-name>/<branch-name> <branch-name>
```

### Step 4: Launch Parallel Subagents

Launch ONE subagent per failing PR in a SINGLE message with multiple Task tool calls.

**Subagent Prompt**:

```text
Fix all CI failures for PR #{NUMBER} in {OWNER}/{REPO}

Branch: {BRANCH_NAME}
Worktree: {WORKTREE_PATH}
Title: {PR_TITLE}
Failing checks: {LIST_OF_FAILING_CHECKS}

Your mission:
1. Navigate to the worktree: cd {WORKTREE_PATH}
2. Identify failures: gh run list --limit 3
3. For EACH failing check:
   a. Get logs: gh run view {RUN_ID} --log-failed
   b. Analyze the failure (read error messages carefully)
   c. Fix the root cause (NEVER disable checks or bypass linters)
   d. Test fix locally if possible
4. Commit changes with descriptive message
5. Push: git push origin {BRANCH_NAME}
6. Wait for CI: gh pr checks {NUMBER} --watch --fail-fast
7. Verify mergeable: gh pr view {NUMBER} --json mergeable,statusCheckRollup

CRITICAL RULES:
- Work ONLY in the provided worktree
- NEVER add config to bypass linters/tests/checks
- ALWAYS fix the actual issue, not symptoms
- Verify PR shows mergeable: "MERGEABLE" before reporting done

Report when complete:
✅ PR: https://github.com/{OWNER}/{REPO}/pull/{NUMBER}
✅ Mergeable: {YES/NO}
✅ All checks: {PASS/FAIL for each}
⚠️ Issues: {list remaining issues or "none"}
```

### Step 5: Monitor Subagents

Wait for all agents to complete using `TaskOutput` with `block=true`.

Verify each PR:

```bash
gh pr view NUMBER --json mergeable,statusCheckRollup \
  --jq '{mergeable, checks: [.statusCheckRollup[] | select(.conclusion != null) | {name, conclusion}]}'
```

### Step 6: Clean Up Worktrees

After all subagents complete:

```bash
git worktree remove ~/git/<repo-name>/<branch-name>
git worktree prune
```

### Step 7: Final Report

```text
## CI Fix Results

Repository: {OWNER}/{REPO}
PRs processed: {N}

✅ FIXED ({N} PRs):
- #{NUMBER}: {TITLE} - all checks passing
...

⚠️ PARTIAL ({N} PRs):
- #{NUMBER}: {remaining issues}
...

❌ FAILED ({N} PRs):
- #{NUMBER}: {reason}
...

Worktrees cleaned up: {N}
```

## Key Differences from /fix-all-pr-ci

| Aspect | /fix-pr-ci | /fix-all-pr-ci |
| ------ | ---------- | -------------- |
| Scope | Current repo only | Current repo only |
| Batch Size | 10 PRs | 5 PRs |
| Worktrees | Uses worktrees | Uses worktrees |
| Cleanup | Cleans worktrees | Cleans worktrees |

## Batching

If > 10 PRs need fixing:

- Process first 10
- Wait for completion
- Process next batch
- Avoids overwhelming the system

## Error Handling

If subagent fails 3 times on same PR:

- Mark PR as "needs human review"
- Log the issue
- Continue with other PRs
- Don't let one failure block everything

## Example Usage

```bash
# From any worktree in the repo
/fix-pr-ci
```

The orchestrator will:

1. Detect current repository
2. Find all open PRs with failing CI
3. Create worktrees for each
4. Launch parallel subagents
5. Monitor and verify
6. Clean up and report

---

**Remember**: Current repo only, use worktrees, fix root causes, verify completion.
