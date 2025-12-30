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

### 2. Clean Up Ambiguous References

**IMPORTANT**: Check for a common problem that causes confusing errors:

```bash
git show-ref origin/main
```

If you see TWO lines (one with `refs/heads/origin/main` and one with `refs/remotes/origin/main`),
you have a LOCAL branch named `origin/main` that conflicts with the remote tracking branch.

**Fix it immediately:**

```bash
git branch -D origin/main
```

This error looks like: `warning: refname 'origin/main' is ambiguous.`

### 3. Discover Worktree Paths

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

**Fix:**

```bash
cd <MAIN_PATH>
git add -A
git commit --amend --no-edit
git push origin main
```

### Error: "warning: refname 'origin/main' is ambiguous"

**Cause:** You have a LOCAL branch named `origin/main` that conflicts with the remote.

**Fix:**

```bash
git branch -D origin/main
```

Then retry the push.

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
