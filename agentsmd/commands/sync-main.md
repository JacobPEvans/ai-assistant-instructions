---
description: Update main from remote and merge into current or all PR branches
model: haiku
author: JacobPEvans
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

- CLAUDE.md "Git Workflow Patterns" - Main synchronization and merge patterns
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
2. **Find and sync main**: Use CLAUDE.md "Main Branch Synchronization" pattern
3. **Merge**: `git merge origin/main --no-edit`
4. **Push**: `git push origin $(git branch --show-current)`
5. **Report**: branch, main SHA, merge status

---

## All Branches Mode (Orchestrator)

Process all open PR branches. Use the subagent-batching skill for parallel patterns.

### Steps

1. **Get repo**: `gh repo view --json nameWithOwner`
2. **Update main**: CRITICAL - must happen first
3. **List open PRs**: `gh pr list --state open --json number,headRefName,title`
4. **Process PRs**: Launch subagents in parallel. Each subagent receives the branch name and must:
   - Fetch latest: `git fetch origin <branch-name>`
   - Create worktree: `git worktree add ~/git/<repo-name>/<branch-name> -b <branch-name> origin/<branch-name>`
   - Merge main: `git merge origin/main --no-edit`
   - Push: `git push origin <branch-name>`
   - Report: branch, status (merged/conflict/failed)
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
