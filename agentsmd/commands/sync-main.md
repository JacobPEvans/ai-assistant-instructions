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
3. **Check for updates**: `git fetch origin main && git merge-base --is-ancestor origin/main HEAD`
4. **Inform user**: Report if branch is behind main with summary of commits
5. **Request confirmation**: Ask user if they want to merge main into current branch
6. **Merge (if confirmed)**: `git merge origin/main --no-edit`
7. **Push (if confirmed)**: `git push origin $(git branch --show-current)`
8. **Report**: branch, main SHA, merge status or "merge declined by user"

---

## All Branches Mode (Orchestrator)

Report sync status for all open PR branches. Use the subagent-batching skill for parallel patterns.

### Steps

1. **Get repo**: `gh repo view --json nameWithOwner`
2. **Update main**: CRITICAL - must happen first
3. **List open PRs**: `gh pr list --state open --json number,headRefName,title`
4. **Check each PR**: Launch subagents in parallel. Each subagent receives the branch name and must:
   - Fetch latest: `git fetch origin <branch-name>`
   - Check if behind main: `git merge-base --is-ancestor origin/main HEAD`
   - Report: branch name, merge status (current/behind/conflict/needs-merge)
   - Do NOT merge or push changes
5. **Compile results**: Gather all reports
6. **Report**: repo, main SHA, merge-readiness for each PR (current/behind/conflict)
7. **Prompt user**: Ask which PRs should be synced with main (if any are behind)
8. **Sync only confirmed**: Only merge confirmed branches after user approval
9. **Cleanup**: `git worktree remove` and `git worktree prune`

---

## Conflict Resolution

Use the merge-conflict-resolution rule.

Key: Read files, understand both versions, combine intelligently, stage resolved files, commit.

## DO NOT

- Blindly use `--theirs` or `--ours`
- Force push unless explicitly asked
- Skip reading conflicted files
