---
description: Troubleshoot and recover from git rebase failures
model: haiku
allowed-tools: Bash(git:*), Bash(gh pr view:*), Bash(gh pr list:*), Read, Grep, Glob
---

# Git Rebase Troubleshoot

Diagnose and recover from `/git-rebase` failures. Only invoke this skill when the primary
`/git-rebase` command encounters errors that the main skill's "EXPECTED ERRORS" section
cannot resolve.

**For generic git/worktree issues**, see:

- `/git-worktree-troubleshooting` - Worktree paths, branch issues, ambiguous refnames
- `/git-precommit-troubleshooting` - Pre-commit hook auto-fixes

---

## Quick Diagnosis

Run ALL of these commands first to understand the current state:

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

# List all worktrees
git worktree list

# Check PR state
gh pr view <branch> --json state,number 2>/dev/null || echo "No PR found"
```

---

## Error: Push Rejected (Non-Fast-Forward)

This error looks like:

```text
! [rejected]        main -> main (non-fast-forward)
error: failed to push some refs to '...'
hint: Updates were rejected because the tip of your current branch is behind
```

Your local main has commits that origin/main doesn't have, AND origin/main has commits
your local main doesn't have. The branches have **diverged**.

### Diagnosing Diverged Branches

```bash
MAIN_PATH=$(git worktree list | grep '\[main\]' | awk '{print $1}')
cd "$MAIN_PATH"
git fetch origin

# Commits on LOCAL main but NOT on origin/main
git log --oneline origin/main..main

# Commits on origin/main but NOT on LOCAL main
git log --oneline main..origin/main
```

### Fixing Diverged Branches

```bash
MAIN_PATH=$(git worktree list | grep '\[main\]' | awk '{print $1}')
cd "$MAIN_PATH"
git fetch origin
git rebase origin/main
git push origin main
```

If this still fails, origin/main was updated AGAIN while you were rebasing.
Start over from Step 1 of `/git-rebase`.

---

## Error: Repository Rule Violations

This error looks like:

```text
remote: error: GH013: Repository rule violations found for refs/heads/main.
remote: - Changes must be made through a pull request.
remote: - 2 of 2 required status checks are expected.
```

### This is NOT a Block - Your Commits CAN Be Pushed

If you're rebasing commits from an open PR, those commits **have been reviewed** and are allowed
to be pushed to main, even with branch protection rules.

**The error means something else is wrong, not branch protection itself.**

### Diagnosis

Check what's actually failing:

```bash
# Status checks in the PR
gh pr view <branch> --json checks

# Required reviews
gh pr view <branch> --json reviews

# Required status check passes
gh pr view <branch> --json statusCheckRollup
```

### Common Actual Causes

1. **Status checks not passing yet** - Wait for CI/tests to pass in the PR
2. **Required reviews not approved** - Get approvals from code reviewers
3. **Merge conflict** - You should have resolved this during rebase

### The Right Order

1. Rebase feature branch onto main
2. Push the rebased branch (triggers CI)
3. **Wait for all checks to pass**
4. Merge rebased branch into main
5. Push main

If checks are failing, fix the code, commit, push to feature branch, and wait for checks again.

**DO NOT use `gh pr merge`** - that bypasses commit signing and is not a true rebase.

---

## Error: Embedded Git Repository Warning

This error looks like:

```text
warning: adding embedded git repository: some-folder
hint: You've added another git repository inside your current repository.
```

There's a folder in your working directory that contains its own `.git` directory
(it's a nested git repository). This usually happens from:

- Old test directories
- Cloned repos inside your repo
- Worktrees created in wrong locations

### Fixing Embedded Repository

Remove the embedded repository from staging:

```bash
git rm --cached some-folder
```

Or completely remove it:

```bash
rm -rf some-folder
```

Or add it to `.gitignore`:

```bash
echo "some-folder/" >> .gitignore
```

---

## Rebase Conflict

Rebase stops mid-way with conflict markers.

### Identifying Conflicts

```bash
git status
git diff --name-only --diff-filter=U
```

### Resolving Each Conflicted File

```bash
# View the conflict
cat <file>

# After manual resolution, stage it
git add <file>
```

### Continuing or Aborting Rebase

```bash
# Continue after resolving
git rebase --continue

# Or abort entirely
git rebase --abort
```

---

## Error: Fast-Forward Merge Failed

Main was updated between rebase and merge.

**Fix:**

```bash
MAIN_PATH=$(git worktree list | grep '\[main\]' | awk '{print $1}')
cd "$MAIN_PATH"
git fetch origin
git reset --hard origin/main
```

Then re-run `/git-rebase` from the beginning.

---

## Error: Feature Branch Push Failed

Force push to feature branch failed.

**Fix:**

```bash
# Ensure you're on the feature branch
git push --force-with-lease origin <branch>
```

---

## Recovery: Aborting In-Progress Rebase

If rebase is stuck and you need to start over:

```bash
git rebase --abort
git status
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

# Check PR state
gh pr view <branch> --json state
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
- Do NOT use `gh pr merge` - this bypasses commit signing and is NOT a rebase
- Do NOT reset main without checking for unique commits
- Do NOT delete branches without confirming they're merged
- Do NOT run interactive rebase (`git rebase -i`)
- Do NOT give up when you see an error - diagnose and fix it
