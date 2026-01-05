---
description: Troubleshoot git worktree, branch, and refname issues
model: haiku
author: JacobPEvans
allowed-tools: Bash(git:*), Read
---

# Git Worktree Troubleshooting

Diagnose and fix worktree, branch, and reference issues.

## Quick Diagnostics

Always run first:

```bash
git worktree list
git branch -a
git status
pwd
```

## Worktree Discovery

**Never assume paths** - always discover:

```bash
git worktree list
# Main: line with [main] - first column is path
# Branch: line with [<branch>] - first column is path
```

Use the worktree-management skill for patterns.

## Critical: Ambiguous Refname

**Warning**: `warning: refname 'origin/main' is ambiguous`

Means TWO things named `origin/main`:

- `refs/heads/origin/main` - LOCAL branch (bad)
- `refs/remotes/origin/main` - remote tracking (good)

**Diagnose**:

```bash
git show-ref origin/main
```

**Fix**:

```bash
git branch -D origin/main  # Delete local branch
git show-ref origin/main   # Verify only 1 line remains
```

## Common Errors

### Main Worktree Not Found

```bash
git worktree add ~/git/<repo>/main main
```

### Branch Worktree Not Found

```bash
git fetch origin <branch>
git worktree add ~/git/<repo>/<branch> <branch>
```

### Branch Not Found

```bash
git fetch origin
git branch -a | grep -i "<branch>"
```

Check spelling or create: `git checkout -b <branch>`

### Uncommitted Changes

```bash
git add . && git commit -m "WIP"          # Commit
git stash push -m "before operation"      # Stash (temporary)
git checkout -- .                         # Discard (DESTRUCTIVE)
```

### Embedded Git Repository

```bash
git rm --cached <folder>     # Remove from staging
rm -rf <folder>              # Or delete completely
echo "<folder>/" >> .gitignore
```

## Recovery: Reset to Clean State

```bash
MAIN_PATH=$(git worktree list | grep '\[main\]' | awk '{print $1}')
BRANCH_PATH=$(git worktree list | grep '\[<branch>\]' | awk '{print $1}')

cd "$BRANCH_PATH" && git fetch origin && git reset --hard origin/<branch>
cd "$MAIN_PATH" && git fetch origin && git reset --hard origin/main
```

## Recovery: Fresh Worktree

```bash
git worktree remove "<path>" --force
git fetch origin
git worktree add "<new-path>" "<branch>"
```

## Reference

- worktree-management skill - Discovery, cleanup, naming
