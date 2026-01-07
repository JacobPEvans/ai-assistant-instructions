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

See CLAUDE.md "Git Workflow Patterns" for branch naming, worktree structure, and lifecycle management.

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

Identify stale worktrees (merged/deleted/gone branches). Remove using `git worktree remove` + `git branch -d`. Run `git worktree prune`.

See CLAUDE.md "Stale Worktree Detection" for detection criteria.

### 4. Switch to Main and Sync

Sync main branch from remote. See CLAUDE.md "Main Branch Synchronization" for the pattern.

### 5. Generate Branch and Worktree Names

Apply branch naming rules from CLAUDE.md "Branch Naming" section. Sanitize for path using CLAUDE.md "Branch Sanitization" pattern.

### 6. Create Worktree

`git worktree add ~/git/<repo-name>/<branch-name> -b <branch-name> main`

See CLAUDE.md "Worktree Structure" for path format.

### 7. Verify and Report

Switch to worktree, verify with `git status`. Report: previous branch, worktrees cleaned, new location.
