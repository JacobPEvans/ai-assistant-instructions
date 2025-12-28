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
ls -la .git/rebase-merge 2>/dev/null || echo "No rebase in progress"

# What's the relationship to main?
git log --oneline main..HEAD 2>/dev/null | head -5
git log --oneline HEAD..main 2>/dev/null | head -5
```

---

## Common Failures

### "Main worktree not found"

**Cause:** Repository doesn't use worktree structure.

**Fix:**

```bash
REPO_NAME=$(basename -s .git $(git config --get remote.origin.url))
echo "Expected main worktree at: ~/git/$REPO_NAME/main"
ls -la ~/git/$REPO_NAME/ 2>/dev/null || echo "Directory doesn't exist"
```

**Resolution:** Create proper worktree structure or run rebase from main branch.

---

### "Branch not found"

**Cause:** Branch doesn't exist locally or remotely.

**Diagnosis:**

```bash
git branch -a | grep -i "BRANCH_NAME"
git fetch origin
git branch -a | grep -i "BRANCH_NAME"
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

```bash
cd ~/git/REPO_NAME/main
git fetch origin
git reset --hard origin/main
# Then re-run /git-rebase
```

---

### "Push rejected"

**Cause:** Remote main has commits not in local.

**Diagnosis:**

```bash
cd ~/git/REPO_NAME/main
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
git push --force-with-lease origin BRANCH_NAME
```

---

## Recovery Procedures

### Abort In-Progress Rebase

```bash
git rebase --abort
git status
```

### Reset to Clean State

```bash
# Reset feature branch to remote
git fetch origin
git reset --hard origin/BRANCH_NAME

# Reset main to remote
cd ~/git/REPO_NAME/main
git fetch origin
git reset --hard origin/main
```

### Start Fresh

```bash
# Remove problematic worktree
git worktree remove ~/git/REPO_NAME/BRANCH_NAME --force

# Re-create from origin
git fetch origin
git worktree add ~/git/REPO_NAME/BRANCH_NAME origin/BRANCH_NAME
```

---

## Verification Commands

After recovery, verify state before retrying:

```bash
# Main is synced with origin
cd ~/git/REPO_NAME/main
git fetch origin
git diff origin/main --stat  # Should show nothing

# Feature branch exists and is clean
cd ~/git/REPO_NAME/BRANCH_NAME
git status  # Should show clean

# No rebase in progress
ls .git/rebase-merge 2>/dev/null && echo "REBASE IN PROGRESS" || echo "OK"
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
