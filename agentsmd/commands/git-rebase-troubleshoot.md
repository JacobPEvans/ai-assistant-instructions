---
description: Troubleshoot and recover from git rebase failures
model: sonnet
allowed-tools: Bash(git:*), Bash(gh pr view:*), Bash(gh pr list:*), Read, Glob, Grep
---

# Git Rebase Troubleshoot

Diagnose and recover from `/git-rebase` failures. Only invoke this skill when the primary
`/git-rebase` command encounters errors that the main skill's "EXPECTED ERRORS" section
cannot resolve.

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

# Check for ambiguous refnames (COMMON PROBLEM)
git show-ref origin/main | wc -l

# What's the relationship to main?
git log --oneline main..HEAD 2>/dev/null | head -5
git log --oneline HEAD..main 2>/dev/null | head -5

# List all worktrees to find paths
git worktree list

# Check PR state
gh pr view <branch> --json state,number 2>/dev/null || echo "No PR found"
```

---

## CRITICAL: Understanding the Ambiguous Refname Warning

If you see this warning:

```text
warning: refname 'origin/main' is ambiguous.
```

**This means you have TWO things named `origin/main`:**

1. `refs/heads/origin/main` - A LOCAL branch someone accidentally named `origin/main`
2. `refs/remotes/origin/main` - The actual remote tracking branch for origin's main

**This is extremely confusing** because git doesn't know which one you mean when you type
`origin/main`. Commands will behave unpredictably.

### Diagnosing Ambiguous Refname

```bash
git show-ref origin/main
```

**Normal output (1 line):**

```text
abc1234 refs/remotes/origin/main
```

**Problem output (2 lines):**

```text
def5678 refs/heads/origin/main        <-- LOCAL BRANCH (DELETE THIS)
abc1234 refs/remotes/origin/main      <-- REMOTE TRACKING (KEEP THIS)
```

### Fixing Ambiguous Refname

Delete the local branch that's causing confusion:

```bash
git branch -D origin/main
```

Then verify:

```bash
git show-ref origin/main
```

Should now show only ONE line with `refs/remotes/origin/main`.

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
You need to restart the entire `/git-rebase` process from Step 1.

---

## Error: Branch Protection / Repository Rules

This error looks like:

```text
remote: error: GH013: Repository rule violations found for refs/heads/main.
remote: - Changes must be made through a pull request.
remote: - 2 of 2 required status checks are expected.
```

The repository has branch protection rules that prevent direct pushes to main.

### This Skill Cannot Complete With Branch Protection

The `/git-rebase` workflow requires pushing **signed commits** directly to main.
GitHub's merge button does NOT preserve commit signatures from local rebases.

**DO NOT use `gh pr merge`** - that bypasses commit signing and is not a true rebase.

### Options

1. **Adjust repository rules** to allow signed commits from authorized users
2. **Contact repository admin** to temporarily allow the push
3. **Use GitHub's merge button** as a last resort (loses commit signatures)

### Why This Matters

The whole point of `/git-rebase` is to:

1. Rebase commits locally (where they get signed)
2. Push signed commits to main
3. PR auto-closes because commits are now in main

Using `gh pr merge` skips step 1-2 and creates unsigned commits on GitHub's servers.

---

## Error: Pre-Commit Hooks Modified Files

This error looks like:

```text
trim trailing whitespace.................................................Passed
fix end of files.........................................................Passed
markdownlint-cli2........................................................Failed
- hook id: markdownlint-cli2
- files were modified by this hook
```

Pre-commit hooks auto-corrected formatting issues (trailing whitespace, end of file
newlines, markdown formatting, etc.). The modified files aren't committed.

### Fixing Pre-Commit Hook Modifications

```bash
MAIN_PATH=$(git worktree list | grep '\[main\]' | awk '{print $1}')
cd "$MAIN_PATH"

# Stage the auto-fixed files
git add -A

# Amend the previous commit to include the fixes
git commit --amend --no-edit

# Try pushing again
git push origin main
```

If the hooks keep modifying files in a loop, there may be a formatting issue
the hook can't fully resolve. Check `git diff` to see what's being changed.

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

If you want to completely remove it:

```bash
rm -rf some-folder
```

Or add it to `.gitignore`:

```bash
echo "some-folder/" >> .gitignore
```

---

## Error: Main Worktree Not Found

No worktree exists for main branch.

**Diagnosis:**

```bash
git worktree list | grep '\[main\]'
```

**Resolution:** Create a main worktree:

```bash
git worktree add /path/to/main main
```

---

## Error: Branch Not Found

Branch doesn't exist locally or remotely.

**Diagnosis:**

```bash
git branch -a | grep -i "<branch>"
git fetch origin
git branch -a | grep -i "<branch>"
```

**Resolution:** Check spelling, fetch from origin, or create the branch.

---

## Error: Uncommitted Changes

Working directory has uncommitted changes.

**Options:**

1. Commit changes: `git add . && git commit -m "WIP"`
2. Stash changes: `git stash push -m "before rebase"`
3. Discard changes: `git checkout -- .` (DESTRUCTIVE)

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

## Recovery Procedures

### Aborting In-Progress Rebase

```bash
git rebase --abort
git status
```

### Resetting to Clean State

```bash
# Find paths
git worktree list

# Reset feature branch to remote (from branch worktree)
cd "<BRANCH_PATH>"
git fetch origin
git reset --hard origin/<branch>

# Reset main to remote (from main worktree)
cd "<MAIN_PATH>"
git fetch origin
git reset --hard origin/main
```

### Starting Fresh with New Worktree

If worktree is corrupted:

```bash
git worktree list
git worktree remove "<path-to-worktree>" --force
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

# Check for ambiguous refnames
git show-ref origin/main | wc -l  # Should be 1

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
- Do NOT assume folder names or paths - always use `git worktree list`
- Do NOT give up when you see an error - diagnose and fix it
