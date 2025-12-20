---
description: Update main from remote and merge into current or all PR branches
model: haiku
allowed-tools: Task, TaskOutput, TodoWrite, Bash(gh:*), Bash(git:*), Bash(git worktree remove:*), Read, Edit, Glob, Grep
---

# Sync Main

Update the local `main` branch from remote and merge it into the current working branch,
or all open PR branches when using the `all` parameter.

## Scope Parameter

| Usage | Scope | Model |
| ----- | ----- | ----- |
| `/sync-main` | Current branch only | haiku |
| `/sync-main all` | All open PR branches | opus |

**CURRENT REPOSITORY ONLY** - This command never crosses into other repositories.

## Related Documentation

- [Merge Conflict Resolution](../rules/merge-conflict-resolution.md) - How to resolve conflicts
- [Subagent Parallelization](../rules/subagent-parallelization.md) - Parallel execution patterns

## Prerequisites

- You must be in a feature branch worktree (not on main itself)
- The current branch should have no uncommitted changes

---

## Single Branch Mode (Default)

### Step 1: Verify Current State

```bash
# Get the current branch name
git branch --show-current

# Check for uncommitted changes
git status --porcelain
```

**Decision point:**

- If current branch is `main`: STOP. Say "You are on main. Switch to a feature branch first."
- If there are uncommitted changes: STOP. Say "You have uncommitted changes. Commit or stash them first."
- Otherwise: Continue.

### Step 2: Find the Main Worktree

```bash
# Get repo name from remote URL
REPO_NAME=$(basename -s .git $(git config --get remote.origin.url))
MAIN_WORKTREE=~/git/$REPO_NAME/main

# Verify it exists
ls -d $MAIN_WORKTREE
```

**If main worktree doesn't exist:**

```bash
git worktree list | grep -E '\[main\]|\[master\]' | awk '{print $1}'
```

### Step 3: Update Main from Remote

```bash
# Use a subshell to safely update the main worktree
(
  cd "$MAIN_WORKTREE"
  git fetch origin main
  git pull origin main
  echo "Main worktree updated. Latest commit:"
  git log -1 --oneline
)
```

### Step 4: Merge Main into Current Branch

```bash
git merge origin/main --no-edit
```

**Three possible outcomes:**

1. **Clean merge**: Continue to Step 5.
2. **Merge conflict**: See Conflict Resolution below.
3. **Already up to date**: Report success and stop.

### Step 5: Push the Updated Branch

```bash
git push origin $(git branch --show-current)
```

### Step 6: Report Results

```text
## Sync Main Results

Branch: <branch-name>
Main updated to: <commit-sha>
Merge status: CLEAN / CONFLICTS_RESOLVED
Conflicts resolved: <N files or "none">
```

---

## All Branches Mode (Orchestrator)

When invoked with the `all` parameter, this command becomes an orchestrator that processes
all open PR branches in the current repository.

### Step 1: Identify the Repository

```bash
gh repo view --json nameWithOwner --jq '.nameWithOwner'
REPO_NAME=$(basename -s .git $(git config --get remote.origin.url))
```

### Step 2: Update Main from Remote

**CRITICAL**: This MUST happen before any PR merges.

```bash
MAIN_WORKTREE=~/git/$REPO_NAME/main
(
  cd $MAIN_WORKTREE
  git fetch origin main
  git pull origin main
)
MAIN_SHA=$(cd $MAIN_WORKTREE && git rev-parse --short HEAD)
echo "Main updated to: $MAIN_SHA"
```

### Step 3: List All Open PRs

```bash
gh pr list --state open --json number,headRefName,title
```

**If no open PRs**: Report "No open PRs to sync" and stop.

### Step 4: Process PRs in Parallel

Launch one Task subagent per PR (maximum 5 concurrent):

**Subagent Prompt**:

```text
Sync main into PR #{NUMBER} branch {BRANCH_NAME}
Repository: {REPO_NAME}

Steps:
1. Fetch and create worktree if needed:
   SAFE_BRANCH="$(printf '%s\n' "{BRANCH_NAME}" | tr -c 'A-Za-z0-9._-/' '_')"
   git fetch origin {BRANCH_NAME}
   git worktree add "$HOME/git/{REPO_NAME}/$SAFE_BRANCH" {BRANCH_NAME}
2. Navigate to worktree: cd "$HOME/git/{REPO_NAME}/$SAFE_BRANCH"
3. Merge: git merge origin/main --no-edit
4. If conflicts: resolve intelligently (combine both sides)
5. Push: git push origin {BRANCH_NAME}

Report: PR#{NUMBER} - CLEAN/CONFLICTS_RESOLVED/FAILED
```

### Batching Strategy

**CRITICAL: Maximum 5 subagents running at once.**

If > 5 PRs:

1. Launch first 5 subagents in parallel
2. Wait for ALL 5 to complete using `TaskOutput` with `block=true`
3. Start next batch of 5
4. Never have more than 5 concurrent subagents

### Step 5: Clean Up Worktrees (Optional)

```bash
# Use sanitized branch directory
SAFE_BRANCH="$(printf '%s\n' "$BRANCH_NAME" | tr -c 'A-Za-z0-9._-/' '_')"
git worktree remove "$HOME/git/$REPO_NAME/$SAFE_BRANCH"
git worktree prune
```

### Step 6: Final Report

```text
## Sync Main into All PRs - Results

Repository: <owner>/<repo>
Main synced to: <commit-sha>
PRs processed: <total>

Clean Merges: PR #N, PR #N...
Conflicts Resolved: PR #N...
Failed: PR #N (reason)...
```

---

## Conflict Resolution

For each conflicted file:

1. **Read the file** to see conflict markers
2. **Understand both versions** before making changes
3. **Resolve by combining intelligently**:
   - Both added different things → Keep BOTH
   - Both modified same thing → Combine intent of BOTH
   - One is a bug fix → Always include the fix
4. **Remove conflict markers** after editing
5. **Stage the resolved file**: `git add <filename>`

After all conflicts resolved:

```bash
git commit --no-edit
```

## DO NOT

- Do NOT run `git checkout --theirs` or `git checkout --ours` blindly
- Do NOT assume "newer is better" for conflicts
- Do NOT skip reading conflicted files before resolving
- Do NOT force push (`--force`) unless explicitly asked

## Example Usage

```bash
# Sync main into current branch only
/sync-main

# Sync main into all open PR branches
/sync-main all
```
