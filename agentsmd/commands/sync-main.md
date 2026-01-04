---
description: Update main from remote and merge into current or all PR branches
model: haiku
allowed-tools: Task, TaskOutput, Bash(gh:*), Bash(git:*), Bash(git worktree remove:*), Read, Grep, Glob, TodoWrite
---

# Sync Main

Update the local `main` branch from remote and merge it into the current working branch,
or all open PR branches when using the `all` parameter.

## Scope Parameter

| Usage | Scope | Model |
| ----- | ----- | ----- |
| `/sync-main` | Current branch only | haiku |
| `/sync-main all` | All open PR branches | opus |

**CURRENT REPOSITORY ONLY** - This command never crosses into other repositories.

## Related

- merge-conflict-resolution rule - How to resolve conflicts
- subagent-parallelization rule - Parallel execution patterns

## Prerequisites

- You must be in a feature branch worktree (not on main itself)
- The current branch should have no uncommitted changes

---

## Single Branch Mode (Default)

### Steps

1. **Verify state**: `git branch --show-current`, `git status --porcelain`
   - STOP if on main or uncommitted changes
2. **Find main worktree**: Use the worktree-management skill
3. **Update main**: `cd "$MAIN_WORKTREE" && git fetch origin main && git pull origin main`
4. **Merge**: `git merge origin/main --no-edit`
5. **Push**: `git push origin $(git branch --show-current)`
6. **Report**: branch, main SHA, merge status

---

## All Branches Mode (Orchestrator)

Process all open PR branches. Use the subagent-batching skill for parallel patterns.

### Steps

1. **Get repo**: `gh repo view --json nameWithOwner`
2. **Update main**: CRITICAL - must happen first
3. **List open PRs**: `gh pr list --state open --json number,headRefName,title`
4. **Process PRs**: Max 5 subagents concurrent. Each: fetch, worktree, merge, push
5. **Cleanup**: `git worktree remove` and `git worktree prune`
6. **Report**: repo, main SHA, clean/conflicts/failed per PR

---

## Conflict Resolution

Use the merge-conflict-resolution rule.

Key: Read files, understand both versions, combine intelligently, stage resolved files, commit.

## DO NOT

- Blindly use `--theirs` or `--ours`
- Force push unless explicitly asked
- Skip reading conflicted files
