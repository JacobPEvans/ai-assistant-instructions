---
description: Rebase a feature branch onto main and push updated main to origin
model: haiku
allowed-tools: Task, TaskOutput, TodoWrite, Bash(gh:*), Bash(git:*), Bash(git worktree remove:*), Bash(git rebase --abort:*), Bash(git rebase --continue:*), Bash(git rebase --skip:*), Read, Edit, Glob, Grep
---

# Git Rebase

Rebase a feature branch onto the latest `main`, then push the updated `main` to `origin/main`.

This command orchestrates the standard workflow for integrating feature branch commits into main while keeping linear history.

## Related Documentation

- [Worktrees](../rules/worktrees.md) - Worktree structure and principles
- [Branch Hygiene](../rules/branch-hygiene.md) - Branch synchronization rules
- [Merge Conflict Resolution](../rules/merge-conflict-resolution.md) - How to resolve conflicts

## Usage

```bash
/git-rebase <source-branch>
```

**Parameters:**

- `source-branch` (required): The feature branch to rebase onto main (e.g., `feat/deploy-containers`, `fix/auth-bug`)

## Prerequisites

- The source branch must exist locally or on the remote
- The current repository must have a main worktree at `~/git/<repo-name>/main`
- No uncommitted changes in the current working directory

---

## Step 1: Validate Prerequisites

### 1.1 Parse and validate source branch name

```bash
SOURCE_BRANCH="$1"

# Validate branch name was provided
if [ -z "$SOURCE_BRANCH" ]; then
  echo "Error: branch name required. Usage: /git-rebase <source-branch>"
  exit 1
fi

# Check if branch exists locally or remotely
if ! git branch -a | grep -q "$SOURCE_BRANCH"; then
  echo "Error: branch '$SOURCE_BRANCH' not found"
  exit 1
fi
```

### 1.2 Find main worktree

```bash
# Get repo name from remote
REPO_NAME=$(basename -s .git $(git config --get remote.origin.url))
MAIN_WORKTREE=~/git/$REPO_NAME/main

# Verify it exists
if [ ! -d "$MAIN_WORKTREE" ]; then
  echo "Error: main worktree not found at $MAIN_WORKTREE"
  exit 1
fi
```

---

## Step 2: Update Main from Remote

```bash
# Update main worktree from origin
(
  cd "$MAIN_WORKTREE"
  git fetch origin main
  git pull origin main
  MAIN_SHA=$(git rev-parse --short HEAD)
  echo "Main updated to: $MAIN_SHA"
)
```

---

## Step 3: Find or Create Source Branch Worktree

### 3.1 Check if worktree exists

```bash
SOURCE_WORKTREE=~/git/$REPO_NAME/$SOURCE_BRANCH

if [ -d "$SOURCE_WORKTREE" ]; then
  echo "Using existing worktree: $SOURCE_WORKTREE"
else
  echo "Creating worktree for $SOURCE_BRANCH..."
  # Fetch the branch from origin if not local
  git fetch origin "$SOURCE_BRANCH:$SOURCE_BRANCH" 2>/dev/null || true

  # Create worktree
  git worktree add "$SOURCE_WORKTREE" "$SOURCE_BRANCH"
fi
```

---

## Step 4: Perform Rebase

```bash
(
  cd "$SOURCE_WORKTREE"

  # Check for uncommitted changes
  if ! git diff-index --quiet HEAD --; then
    echo "Error: uncommitted changes in $SOURCE_BRANCH. Commit or stash them first."
    exit 1
  fi

  # Get commit count
  BEFORE_COUNT=$(git log --oneline origin/main.."$SOURCE_BRANCH" | wc -l)

  # Attempt rebase
  if git rebase main; then
    AFTER_COUNT=$(git log --oneline main.."$SOURCE_BRANCH" | wc -l)
    echo "Rebase successful"
    echo "Commits to push: $AFTER_COUNT"
  else
    echo "Rebase conflict detected"
    # Exit with special code to indicate conflicts
    exit 42
  fi
)

REBASE_EXIT=$?

# Handle rebase conflicts
if [ $REBASE_EXIT -eq 42 ]; then
  echo ""
  echo "## Rebase Conflict Detected"
  echo ""
  echo "The rebase encountered conflicts. Resolve them using:"
  echo "1. Navigate to the worktree: cd $SOURCE_WORKTREE"
  echo "2. Review conflicts and resolve them"
  echo "3. Stage resolved files: git add <file>"
  echo "4. Continue rebase: git rebase --continue"
  echo "5. Once done, push from main: cd $MAIN_WORKTREE && git merge $SOURCE_BRANCH && git push origin main"
  exit 1
fi
```

---

## Step 5: Update Main with Rebased Branch

### 5.1 Merge rebased branch into main

```bash
(
  cd "$MAIN_WORKTREE"

  # Fetch the source branch
  git fetch origin "$SOURCE_BRANCH"

  # Merge (should be fast-forward)
  if git merge --ff-only "origin/$SOURCE_BRANCH"; then
    NEW_SHA=$(git rev-parse --short HEAD)
    echo "Main updated with $SOURCE_BRANCH: $NEW_SHA"
  else
    echo "Warning: Could not fast-forward merge. Manual review needed."
    exit 1
  fi
)
```

---

## Step 6: Push Main to Origin

```bash
(
  cd "$MAIN_WORKTREE"

  # Verify we have commits to push
  if git diff --quiet origin/main..main; then
    echo "No new commits to push"
    exit 0
  fi

  # Push to origin
  if git push origin main; then
    COMMIT_COUNT=$(git log --oneline origin/main~$(git log --oneline origin/main..main | wc -l)..origin/main | wc -l)
    echo "Successfully pushed $COMMIT_COUNT new commits to origin/main"
  else
    echo "Error: Failed to push main to origin"
    exit 1
  fi
)
```

---

## Step 7: Report Results

```text
## Git Rebase Complete

Source Branch: <source-branch>
Main Updated: <commit-sha>
Commits Integrated: <count>
Status: SUCCESS

Next Steps:
1. Verify on GitHub that your PR is updated
2. If desired, delete the source branch: git branch -d <source-branch>
3. Clean up worktree if no longer needed: git worktree remove <worktree-path>
```

---

## Handling Rebase Conflicts

If a rebase conflict occurs:

### Manual Resolution Steps

1. **Navigate to the source worktree**:

   ```bash
   cd ~/git/<repo-name>/<source-branch>
   ```

2. **View conflicted files**:

   ```bash
   git status
   ```

3. **For each conflicted file**:
   - Read the file to understand both versions
   - Manually resolve the conflicts (remove conflict markers)
   - Stage the resolved file: `git add <file>`

4. **Continue the rebase**:

   ```bash
   git rebase --continue
   ```

5. **If you need to abort**:

   ```bash
   git rebase --abort
   ```

6. **Once rebase is complete**, merge into main and push:

   ```bash
   cd ~/git/<repo-name>/main
   git merge --ff-only <source-branch>
   git push origin main
   ```

---

## Troubleshooting

### "Main worktree not found"

Ensure your repository uses the worktree structure. The main branch should be at `~/git/<repo-name>/main`:

```bash
ls -d ~/git/<repo-name>/main
```

### "Branch not found"

The branch doesn't exist locally or on remote. Verify:

```bash
git branch -a | grep <branch-name>
```

### "Fast-forward merge failed"

Main was updated between the rebase and merge. Run `/git-rebase <branch>` again.

### "Push rejected"

Your local main has commits that remote doesn't. This shouldn't happen if the rebase was clean. Check:

```bash
git log origin/main..main
```

---

## DO NOT

- Do NOT use `git rebase -i` (interactive rebase) - this requires manual intervention
- Do NOT rebase directly on to arbitrary branches - only onto main
- Do NOT force push (`--force`) - the command uses fast-forward only
- Do NOT run while there are uncommitted changes

## Example Usage

```bash
# Rebase feat/deploy-containers onto main
/git-rebase feat/deploy-containers

# Rebase fix/auth-bug onto main
/git-rebase fix/auth-bug
```
