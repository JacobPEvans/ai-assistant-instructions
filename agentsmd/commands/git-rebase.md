---
description: Rebase a feature branch onto main and push updated main to origin
model: haiku
allowed-tools: Bash(git:*)
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

## Execute These Three Steps

### Step 1: Update main from origin

```bash
REPO=$(basename -s .git $(git config --get remote.origin.url))
cd ~/git/$REPO/main && git fetch origin && git reset --hard origin/main
```

### Step 2: Rebase branch onto main, merge into main

```bash
BRANCH="<branch>"
REPO=$(basename -s .git $(git config --get remote.origin.url))
cd ~/git/$REPO/$BRANCH && git rebase main && git push --force-with-lease origin $BRANCH
cd ~/git/$REPO/main && git merge --ff-only $BRANCH
```

### Step 3: PUSH MAIN TO ORIGIN (THIS IS THE WHOLE POINT)

```bash
REPO=$(basename -s .git $(git config --get remote.origin.url))
cd ~/git/$REPO/main && git push origin main
```

---

## Verify Completion

Run this verification command:

```bash
REPO=$(basename -s .git $(git config --get remote.origin.url))
cd ~/git/$REPO/main && git fetch origin && git rev-parse HEAD && git rev-parse origin/main
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
