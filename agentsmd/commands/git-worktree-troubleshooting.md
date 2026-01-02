---
description: Troubleshoot git worktree, branch, and refname issues
model: haiku
allowed-tools: Bash(git:*), Bash(gh pr view:*), Read, Grep, Glob
---

# Git Worktree Troubleshooting

Diagnose and fix generic git worktree, branch, and reference issues that affect any git
workflow (rebase, commit, merge, etc.).

---

## Discovering Worktree Paths

**IMPORTANT**: Never assume folder names or paths. Always discover them:

```bash
git worktree list
```

From the output:

- **MAIN_PATH**: Line ending with `[main]` - first column is the path
- **BRANCH_PATH**: Line ending with `[<branch>]` - first column is the path
- **ANY_PATH**: Use the worktree list output to find the correct path

Use these discovered paths in all commands.

---

## CRITICAL: Understanding Ambiguous Refname Warning

If you see this warning:

```text
warning: refname 'origin/main' is ambiguous.
```

**This means you have TWO things named `origin/main`:**

1. `refs/heads/origin/main` - A LOCAL branch someone accidentally named `origin/main`
2. `refs/remotes/origin/main` - The actual remote tracking branch for origin's main

Git doesn't know which one you mean. Commands will behave unpredictably.

### Diagnosis

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

### Fix

Delete the local branch causing the conflict:

```bash
git branch -D origin/main
```

Verify:

```bash
git show-ref origin/main
```

Should now show only ONE line with `refs/remotes/origin/main`.

---

## Error: Main Worktree Not Found

No worktree exists for the main branch.

**Diagnosis:**

```bash
git worktree list | grep '\[main\]'
```

**Resolution:** Create a main worktree:

```bash
git worktree add ~/git/<repo>/main main
```

---

## Error: Branch Worktree Not Found

No worktree exists for your feature branch.

**Diagnosis:**

```bash
git worktree list
git branch -a | grep <branch>
```

**Resolution:** Create the worktree:

```bash
git fetch origin <branch>
git worktree add ~/git/<repo>/<branch> <branch>
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

**Resolution:**

- Check spelling
- Run `git fetch origin` to update remote tracking branches
- Create the branch if it doesn't exist: `git checkout -b <branch>`

---

## Error: Uncommitted Changes

Working directory has uncommitted changes preventing git operations.

**Options:**

1. **Commit changes:**

   ```bash
   git add . && git commit -m "WIP"
   ```

2. **Stash changes (temporary):**

   ```bash
   git stash push -m "before rebase"
   ```

3. **Discard changes (DESTRUCTIVE):**

   ```bash
   git checkout -- .
   ```

---

## Error: Embedded Git Repository Warning

This error looks like:

```text
warning: adding embedded git repository: some-folder
hint: You've added another git repository inside your current repository.
```

There's a folder in your working directory with its own `.git` directory (nested repo).

**Common causes:**

- Old test directories
- Cloned repos inside your repo
- Worktrees created in wrong locations

**Fix:**

Remove from staging:

```bash
git rm --cached some-folder
```

Or completely remove it:

```bash
rm -rf some-folder
```

Or add to `.gitignore`:

```bash
echo "some-folder/" >> .gitignore
```

---

## Recovery: Resetting to Clean State

When worktrees get out of sync with remote:

```bash
# Discover paths
MAIN_PATH=$(git worktree list | grep '\[main\]' | awk '{print $1}')
BRANCH_PATH=$(git worktree list | grep '\[<branch>\]' | awk '{print $1}')

# Reset feature branch to remote
cd "$BRANCH_PATH"
git fetch origin
git reset --hard origin/<branch>

# Reset main to remote
cd "$MAIN_PATH"
git fetch origin
git reset --hard origin/main
```

---

## Recovery: Starting Fresh with New Worktree

If a worktree is corrupted:

```bash
git worktree list
git worktree remove "<path-to-worktree>" --force
git fetch origin
git worktree add "<new-path>" "<branch>"
```

---

## DO NOT

- Do NOT assume folder names or paths - always use `git worktree list`
- Do NOT delete worktrees without removing them first (`git worktree remove`)
- Do NOT create worktrees with hardcoded paths that include repo names
- Do NOT delete branches without confirming they're merged
