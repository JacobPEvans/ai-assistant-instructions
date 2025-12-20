---
description: Update main from remote and merge into current branch
model: haiku
allowed-tools: Bash(git:*), Read, Edit, Glob, Grep
---

# Sync Main

Update the local `main` branch from remote and merge it into the current working branch.

## Prerequisites

- You must be in a feature branch worktree (not on main itself)
- The current branch should have no uncommitted changes

## Step-by-Step Instructions

Follow these steps EXACTLY in order. Do not skip steps.

### Step 1: Verify Current State

Run these commands to understand where you are:

```bash
# Get the current branch name
git branch --show-current

# Check for uncommitted changes
git status --porcelain
```

**Decision point:**

- If current branch is `main`: STOP. Say "You are on main. Switch to a feature branch first."
- If there are uncommitted changes: STOP. Say "You have uncommitted changes. Commit or stash them first."
- Otherwise: Continue to Step 2.

### Step 2: Find the Main Worktree

The main worktree is typically at `~/git/<repo-name>/main`. Find it:

```bash
# Get repo name from remote URL
REPO_NAME=$(basename -s .git $(git config --get remote.origin.url))
MAIN_WORKTREE=~/git/$REPO_NAME/main

# Verify it exists
ls -d $MAIN_WORKTREE
```

**If main worktree doesn't exist:**

```bash
# Find it from worktree list
git worktree list | grep -E '\[main\]|\[master\]' | awk '{print $1}'
```

### Step 3: Update Main from Remote

Navigate to the main worktree and pull the latest:

```bash
# Save current directory
CURRENT_DIR=$(pwd)

# Use a subshell to safely update the main worktree. This is more robust as the
# directory change is isolated.
(
  cd "$MAIN_WORKTREE"
  git fetch origin main
  git pull origin main
  echo "Main worktree updated. Latest commit:"
  git log -1 --oneline
)

# Return to original directory is now implicit
```

### Step 4: Merge Main into Current Branch

Attempt the merge:

```bash
git merge origin/main --no-edit
```

**Three possible outcomes:**

1. **Clean merge (no conflicts)**: Continue to Step 5.
2. **Merge conflict**: Go to Step 4a (Conflict Resolution).
3. **Already up to date**: Report success and stop.

### Step 4a: Conflict Resolution

If there are conflicts, follow these steps EXACTLY:

#### 4a.1: List Conflicted Files

```bash
git diff --name-only --diff-filter=U
```

#### 4a.2: For EACH Conflicted File

1. **Read the file** to see the conflict markers:

   ```bash
   # Look for these markers in the file:
   # <<<<<<< HEAD
   # (your branch's version)
   # =======
   # (main's version)
   # >>>>>>> origin/main
   ```

2. **Understand both versions:**
   - HEAD = your current branch's changes
   - origin/main = what main branch has

3. **Resolve by combining both changes intelligently:**
   - If both added different things: Keep BOTH additions
   - If both modified the same thing: Combine the intent of BOTH
   - If one is a bug fix: Always include the fix
   - NEVER just delete one side blindly

4. **Remove the conflict markers** after editing.

5. **Stage the resolved file:**

   ```bash
   git add <filename>
   ```

#### 4a.3: After ALL Conflicts Are Resolved

```bash
# Complete the merge
git commit --no-edit
```

### Step 5: Push the Updated Branch

```bash
git push origin $(git branch --show-current)
```

### Step 6: Report Results

Print a summary:

```text
## Sync Main Results

Branch: <branch-name>
Main updated to: <commit-sha>
Merge status: <CLEAN / CONFLICTS_RESOLVED>
Conflicts resolved: <N files or "none">

Ready for next steps.
```

## Common Errors and Fixes

| Error | Cause | Fix |
| ----- | ----- | --- |
| "not a git repository" | Wrong directory | Navigate to the repo first |
| "uncommitted changes" | Dirty working tree | Run `git stash` or commit first |
| "merge conflict" | Divergent changes | Follow Step 4a carefully |
| "cannot pull with rebase" | Uncommitted changes | Commit or stash first |
| "failed to push" | Remote has new changes | Pull first, then push |

## DO NOT

- Do NOT run `git checkout --theirs` or `git checkout --ours` blindly
- Do NOT assume "newer is better" for conflicts
- Do NOT skip reading conflicted files before resolving
- Do NOT force push (`--force`) unless explicitly asked
