---
description: Fix CI failures on open PRs in the current repository
model: sonnet
author: JacobPEvans
allowed-tools: Task, TaskOutput, Bash(gh:*), Bash(git:*), Bash(git worktree remove:*), Read, Grep, Glob, TodoWrite
---

# Fix PR CI Failures

Fix CI failures on open PRs in the **current repository only**.

## Scope

| Usage | Scope | Batch Size |
| ----- | ----- | ---------- |
| `/fix-pr-ci` | Current PR only | 1 |
| `/fix-pr-ci all` | All open PRs with failing CI | 5 |

## Related

Use the worktrees rule, subagent-parallelization rule, and merge-conflict-resolution rule.

## Steps

### 1. Identify Repository and Scope

```bash
gh repo view --json nameWithOwner --jq '.nameWithOwner'
gh pr view --json number,headRefName,title,statusCheckRollup,mergeable  # single
gh pr list --json number,headRefName,title,statusCheckRollup,mergeable  # all
```

### 2. Filter for Failing CI

Use the pr-health-check skill. PRs need fixing when any check has `conclusion: "FAILURE"` or `mergeable != "MERGEABLE"`.

### 3. Create Worktrees

```bash
SAFE_BRANCH_DIR="$(printf '%s\n' "$BRANCH_NAME" | tr -c 'A-Za-z0-9._-/' '_')"
git worktree add "$HOME/git/<repo-name>/$SAFE_BRANCH_DIR" "$BRANCH_NAME"
```

### 4. Launch Subagents

**Single**: One subagent. **All**: Batches of 5 max (use the subagent-batching skill).

**Subagent prompt**: Fix CI for PR #{N} at {PATH}. Steps: `gh run list`, `gh run view {ID} --log-failed`, fix root cause, test locally, commit, push.

### 5. Validate and Cleanup

```bash
gh pr view NUMBER --json mergeable,statusCheckRollup
git worktree remove "$HOME/git/<repo-name>/$SAFE_BRANCH_DIR"
git worktree prune
```

### 6. Report

```text
## CI Fix Results
Repository: {OWNER}/{REPO}
FIXED: #{N}...
BLOCKED: #{N} (reason)...
```

## Error Handling

If subagent fails 3 times: mark "needs human review", continue with other PRs.
