---
description: Initialize a clean worktree for new development work
model: haiku
author: JacobPEvans
allowed-tools: Task, TaskOutput, Bash(awk:*), Bash(basename:*), Bash(cd:*), Bash(gh pr list:*), Bash(gh pr view:*), Bash(git branch:*), Bash(git checkout:*), Bash(git fetch:*), Bash(git pull:*), Bash(git rev-parse:*), Bash(git status:*), Bash(git switch:*), Bash(git worktree add:*), Bash(git worktree list:*), Bash(git worktree prune:*), Bash(git worktree remove:*), Bash(grep:*), Bash(head:*), Bash(ls:*), Bash(mkdir:*), Bash(pwd:*), Bash(tr:*), TodoWrite
---

# Init Worktree

**CRITICAL**: All development work MUST be done in a clean worktree. This command ensures isolation between concurrent sessions
and prevents accidental changes on main.

Initialize a clean worktree in `~/git/<repo-name>/<branch-name>/` for new development work.

## Related

Use the worktrees rule and branch-hygiene rule.

## Usage

```bash
/init-worktree [description]
```

**Parameters:**

- `description` (optional): Brief description for branch/worktree naming (e.g., "fix login bug", "add dark mode")

If no description provided, will prompt for one.

## Steps

### 1. Validate

Verify git repo: `git rev-parse --is-inside-work-tree`. Get repo name: `basename $(git rev-parse --show-toplevel)`.

### 2. Remember State

Note current branch and directory for reporting.

### 3. Clean Stale Worktrees

Use the worktree-management skill. Remove if merged/deleted/clean. Run `git worktree prune`.

### 4. Switch to Main and Sync

See the worktree-management skill for main branch synchronization and merging patterns.

### 5. Generate Branch and Worktree Names

**Branch naming**: lowercase, spaces → hyphens, prefix `feat/` (default) or `fix/` (if contains "fix"/"bug").

**Worktree path**: `~/git/<repo-name>/<branch-name>/`

Examples: "add dark mode" → `feat/add-dark-mode`, "fix login bug" → `fix/login-bug`

See the worktree-management skill for branch naming conventions and worktree path structure.

### 6. Create Worktree

`git worktree add ~/git/<repo-name>/<branch-name> -b <branch-name> main`

### 7. Verify and Report

Switch to worktree, verify with `git status`. Report: previous branch, worktrees cleaned, new location.
