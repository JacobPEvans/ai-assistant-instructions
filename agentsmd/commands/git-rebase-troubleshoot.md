---
description: Troubleshoot and recover from git rebase failures
model: sonnet
allowed-tools: Bash(git:*), Read, Glob, Grep
---

# Git Rebase Troubleshoot

Diagnose and recover from `/git-rebase` failures. Only invoke this skill when the primary
`/git-rebase` command encounters errors.

## Quick Diagnosis

Run these commands to understand the current state:

```bash
# Where are we?
pwd
git status

# What branch?
git branch --show-current

# Is a rebase in progress?
ls -la .git/rebase-{merge,apply} 2>/dev/null || echo "No rebase in progress"

# What's the relationship to main?
git log --oneline main..HEAD 2>/dev/null | head -5
git log --oneline HEAD..main 2>/dev/null | head -5

# List all worktrees to find paths
git worktree list
```

---

## Discovering Worktree Paths

**IMPORTANT**: Never assume folder names or paths. Always discover them:

```bash
git worktree list
```

From the output:

- **MAIN_PATH**: Line ending with `[main]` - first column is the path
- **BRANCH_PATH**: Line ending with `[<branch>]` - first column is the path

Use these discovered paths in all commands below.

---

## Common Failures

### "Main worktree not found"

**Cause:** No worktree exists for main branch.

**Diagnosis:**

```bash
git worktree list | grep '\[main\]'
```

**Resolution:** Create a main worktree or ensure one exists in your structure.

---

### "Branch not found"

**Cause:** Branch doesn't exist locally or remotely.

**Diagnosis:**

```bash
git branch -a | grep -i "<branch>"
git fetch origin
git branch -a | grep -i "<branch>"
```

**Resolution:** Check spelling, fetch from origin, or create the branch.

---

### "Uncommitted changes"

**Cause:** Working directory has uncommitted changes.

**Options:**

1. Commit changes: `git add . && git commit -m "WIP"`
2. Stash changes: `git stash push -m "before rebase"`
3. Discard changes: `git checkout -- .` (DESTRUCTIVE)

---

### Rebase Conflict

**Symptoms:** Rebase stops mid-way with conflict markers.

#### Step 1: Identify conflicts

```bash
git status
git diff --name-only --diff-filter=U
```

#### Step 2: For each conflicted file

```bash
# View the conflict
cat <file>

# After manual resolution, stage it
git add <file>
```

#### Step 3: Continue or abort

```bash
# Continue after resolving
git rebase --continue

# Or abort entirely
git rebase --abort
```

---

### "Fast-forward merge failed"

**Cause:** Main was updated between rebase and merge.

**Fix:**

First, discover your main worktree path:

```bash
MAIN_PATH=$(git worktree list | grep '\[main\]' | awk '{print $1}')
```

Then update:

```bash
cd "$MAIN_PATH"
git fetch origin
git reset --hard origin/main
# Then re-run /git-rebase
```

---

### "Push rejected"

**Cause:** Remote main has commits not in local.

**Diagnosis:**

First, discover your main worktree path:

```bash
MAIN_PATH=$(git worktree list | grep '\[main\]' | awk '{print $1}')
cd "$MAIN_PATH"
git fetch origin
git log --oneline origin/main..main
git log --oneline main..origin/main
```

**If local has unique commits:**
This shouldn't happen after a clean rebase. Investigate before force pushing.

**If remote is ahead:**
Update main and re-run rebase.

---

### Feature Branch Push Failed

**Cause:** Force push to feature branch failed.

**Fix:**

```bash
# Ensure you're on the feature branch
git push --force-with-lease origin <branch>
```

---

## Recovery Procedures

### Abort In-Progress Rebase

```bash
git rebase --abort
git status
```

### Reset to Clean State

First, discover worktree paths:

```bash
git worktree list
# Find MAIN_PATH and BRANCH_PATH from output
```

Then reset:

```bash
# Reset feature branch to remote (from branch worktree)
git fetch origin
git reset --hard origin/<branch>

# Reset main to remote (from main worktree)
cd "<MAIN_PATH>"
git fetch origin
git reset --hard origin/main
```

### Start Fresh

If worktree is corrupted, remove and recreate:

```bash
# Find the problematic worktree path
git worktree list

# Remove it
git worktree remove "<path-to-worktree>" --force

# Re-create from origin
git fetch origin
git worktree add "<new-path>" "<branch>"
```

---

## Verification Commands

After recovery, verify state before retrying:

```bash
# Discover paths
MAIN_PATH=$(git worktree list | grep '\[main\]' | awk '{print $1}')
BRANCH_PATH=$(git worktree list | grep '\[<branch>\]' | awk '{print $1}')

# Main is synced with origin
cd "$MAIN_PATH"
git fetch origin
git diff origin/main --stat  # Should show nothing

# Feature branch exists and is clean
cd "$BRANCH_PATH"
git status  # Should show clean

# No rebase in progress
ls .git/rebase-{merge,apply} 2>/dev/null && echo "REBASE IN PROGRESS" || echo "OK"
```

---

## When to Escalate

If these don't resolve the issue:

1. Check git reflog: `git reflog`
2. Review recent operations: `git log -10 --oneline`
3. Ask user for manual intervention

---

## DO NOT

- Do NOT use `--force` (use `--force-with-lease`)
- Do NOT reset main without checking for unique commits
- Do NOT delete branches without confirming they're merged
- Do NOT run interactive rebase (`git rebase -i`)
- Do NOT assume folder names or paths - always use `git worktree list`
