---
description: Rebase a feature branch onto main and push updated main to origin
model: haiku
allowed-tools: Bash(git:*), Bash(gh pr view:*), Bash(gh pr list:*)
---

# Git Rebase

## GOAL

Push `<branch>` commits to `origin/main`.

## SUCCESS CRITERIA

**YOU ARE NOT DONE** until `git push origin main` completes successfully.

## Usage

```text
/git-rebase <branch>
```

---

## Prerequisites Check

Before executing, verify these conditions. If any fail, STOP and follow the guidance.

### 1. PR Must Exist

```bash
gh pr view <branch> --json number,state
```

- If PR exists and is open: Continue
- If no PR exists: STOP. Run `/commit-commands:commit-push-pr` or `gh pr create` first
- If PR is closed/merged: STOP. Nothing to rebase

### 2. Discover Worktree Paths

```bash
git worktree list
```

Find these two paths from the output:

- **MAIN_PATH**: The line ending with `[main]` - use the first column (the path)
- **BRANCH_PATH**: The line ending with `[<branch>]` - use the first column

If BRANCH_PATH not found: You need to create a worktree or run from a worktree with that branch.

---

## Execute These Four Steps

### Step 1: Update main from origin

Navigate to the main worktree (use MAIN_PATH from discovery) and sync:

```bash
cd <MAIN_PATH>
git fetch origin
git reset --hard origin/main
```

### Step 2: Rebase branch onto main

Navigate to the branch worktree (use BRANCH_PATH from discovery):

```bash
cd <BRANCH_PATH>
git rebase main
```

If rebase fails with conflicts: Run `/git-rebase-troubleshoot`

### Step 3: Push rebased branch and merge into main

```bash
cd <BRANCH_PATH>
git push --force-with-lease origin <branch>

cd <MAIN_PATH>
git merge --ff-only <branch>
```

### Step 4: PUSH MAIN TO ORIGIN (THIS IS THE WHOLE POINT)

```bash
cd <MAIN_PATH>
git push origin main
```

---

## Verify Completion

```bash
cd <MAIN_PATH>
git fetch origin
git rev-parse HEAD
git rev-parse origin/main
```

**Task is complete ONLY if both SHAs match.**

---

## Report Format

```text
## Git Rebase Complete

Branch: <branch>
Commits pushed: <count>
Main SHA: <sha>

✓ origin/main updated
```

---

## If Any Step Fails

Run `/git-rebase-troubleshoot` for diagnosis and recovery.

---

## DO NOT

- Stop after "Rebase successful" - you must also push main
- Use `git rebase -i` (interactive)
- Use `--force` (use `--force-with-lease`)
- Report success until origin/main is updated
- Assume any folder naming conventions
