---
description: Rebase a feature branch onto main and push updated main to origin
model: haiku
allowed-tools: Bash(git:*), Bash(gh pr view:*), Bash(gh pr list:*), Bash(gh pr create:*)
---

# Git Rebase

## GOAL

Push `<branch>` commits to `origin/main`.

## SUCCESS CRITERIA

**YOU ARE NOT DONE** until `git push origin main` completes successfully.

If push fails, **DO NOT STOP**. Read the error, fix it, and try again.

## What This Command Does

```text
feature-branch ──rebase──> local main ──push──> origin/main
                                                    │
                                                    ▼
                                          PR auto-closes
```

When your commits land on `origin/main`, GitHub automatically marks the PR as merged.

## Usage

```text
/git-rebase <branch>
```

---

## Prerequisites Check

### 1. PR Must Exist

```bash
gh pr view <branch> --json number,state
```

- If PR exists and is open: Continue
- If no PR exists: STOP. Run `/commit-commands:commit-push-pr` or `gh pr create` first
- If PR is closed/merged: STOP. Nothing to rebase

### 2. Check for Ambiguous References

If you see this warning during operations: `warning: refname 'origin/main' is ambiguous.`

This means you have a local branch named `origin/main` conflicting with the remote tracking
branch. See `/git-worktree-troubleshooting` for diagnosis and fix.

Quick check:

```bash
git show-ref origin/main
```

If TWO lines appear, run `/git-worktree-troubleshooting` to fix it.

### 3. Discover Worktree Paths

See `/git-worktree-troubleshooting` for detailed instructions. Quick discovery:

```bash
git worktree list
```

- **MAIN_PATH**: Line ending with `[main]` - first column is the path
- **BRANCH_PATH**: Line ending with `[<branch>]` - first column is the path

If BRANCH_PATH not found: See `/git-worktree-troubleshooting` for how to create it.

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

**If rebase fails with conflicts:** Run `/git-rebase-troubleshoot`

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

## EXPECTED ERRORS (Do Not Give Up)

These errors are NORMAL. Fix them and continue.

### Error: "non-fast-forward" or "Updates were rejected"

**Cause:** origin/main has commits you don't have locally.

**Fix:**

```bash
cd <MAIN_PATH>
git fetch origin
git rebase origin/main
git push origin main
```

If that still fails, origin/main was updated while you were working. Start over from Step 1.

### Error: "Repository rule violations" or "Changes must be made through a pull request"

**Cause:** Some other GitHub rule is being violated (not branch protection for reviewed commits).

**Why this happens:** The commits you're pushing ARE on the open PR, so they've been reviewed and
should be pushable. If you get this error, check:

1. **Status checks passing**: `gh pr view <branch> --json checks`
2. **All required reviews approved**: `gh pr view <branch> --json reviews`
3. **No conflicts with main**: You already rebased, so this shouldn't happen

**If status checks are failing:**

```bash
cd <BRANCH_PATH>
git push --force-with-lease origin <branch>
# Wait for checks to pass in the PR
cd <MAIN_PATH>
git merge --ff-only <branch>
git push origin main
```

**DO NOT use `gh pr merge`** - that bypasses commit signing and is not a true rebase.

### Error: Pre-commit hooks modified files

**Cause:** Pre-commit hooks (markdownlint, etc.) auto-fixed files.

See `/git-precommit-troubleshooting` for detailed diagnosis and recovery steps.

**Quick fix:**

```bash
cd <MAIN_PATH>
git add -A
git commit --amend --no-edit
git push origin main
```

### Error: "warning: refname 'origin/main' is ambiguous"

See `/git-worktree-troubleshooting` under "CRITICAL: Understanding Ambiguous Refname Warning"
for full explanation and fix. Quick command:

```bash
git branch -D origin/main
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

Also verify the PR closed:

```bash
gh pr view <branch> --json state
```

Should show `"state":"MERGED"`.

---

## Report Format

```text
## Git Rebase Complete

Branch: <branch>
Commits pushed: <count>
Main SHA: <sha>
PR State: MERGED

origin/main updated
```

---

## If You Cannot Fix The Error

Run `/git-rebase-troubleshoot` for detailed diagnosis and recovery.

---

## DO NOT

- Do NOT stop after "Rebase successful" - you must also push main
- Do NOT stop when you see an error - READ IT and FIX IT
- Do NOT use `git rebase -i` (interactive)
- Do NOT use `--force` (use `--force-with-lease`)
- Do NOT use `gh pr merge` - this bypasses commit signing and is NOT a rebase
- Do NOT report success until origin/main is updated AND PR is merged
- Do NOT assume any folder naming conventions
