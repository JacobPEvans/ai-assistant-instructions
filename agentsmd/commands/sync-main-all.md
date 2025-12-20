---
description: Update main from remote and merge into ALL open PR branches
model: opus
allowed-tools: Task, TaskOutput, TodoWrite, Bash(gh:*), Bash(git:*), Read, Edit, Glob, Grep
---

# Sync Main into All PRs

Update the local `main` branch from remote and merge it into ALL open pull request branches in
the current repository.

## Scope

**CURRENT REPOSITORY ONLY** - This command operates on the repository you're currently in.

## Related Documentation

- [Merge Conflict Resolution](../rules/merge-conflict-resolution.md) - How to resolve conflicts
- [Subagent Parallelization](../rules/subagent-parallelization.md) - Parallel execution patterns

## Step-by-Step Instructions

Follow these steps EXACTLY in order. Do not skip steps.

### Step 1: Identify the Repository

```bash
# Get repo owner and name
gh repo view --json nameWithOwner --jq '.nameWithOwner'

# Get repo name for worktree paths
REPO_NAME=$(basename -s .git $(git config --get remote.origin.url))
```

### Step 2: Update Main from Remote

**CRITICAL**: This MUST happen before any PR merges.

```bash
# Find main worktree
MAIN_WORKTREE=~/git/$REPO_NAME/main

# Navigate to main worktree
cd $MAIN_WORKTREE

# Fetch and pull latest from remote
git fetch origin main
git pull origin main

# Record the commit SHA for reporting
MAIN_SHA=$(git rev-parse --short HEAD)
echo "Main updated to: $MAIN_SHA"
```

### Step 3: List All Open PRs

```bash
gh pr list --state open --json number,headRefName,title
```

**If no open PRs**: Report "No open PRs to sync" and stop.

Save this list. You will process each PR.

### Step 4: Process PRs in Parallel (Recommended)

**IMPORTANT**: Use parallel execution to process all PRs simultaneously for maximum efficiency.

Launch one Task subagent per PR (maximum 5 concurrent to prevent resource exhaustion):

```bash
# Use the Task tool with multiple invocations in a single message
# Each subagent processes one PR following Steps 4.1-4.6 below
```

Each subagent receives:

- PR number
- Branch name
- Repository name

Each subagent executes Steps 4.1-4.6 independently:

### Step 4.1: Create Worktree (If Needed)

```bash
BRANCH_NAME=<assigned-branch>
PR_NUMBER=<assigned-pr-number>

# Fetch the branch
git fetch origin "$BRANCH_NAME"

# Check if worktree already exists
WORKTREE_PATH=~/git/$REPO_NAME/"$BRANCH_NAME"
if [ -d "$WORKTREE_PATH" ]; then
    echo "Worktree exists: $WORKTREE_PATH"
else
    git worktree add "$WORKTREE_PATH" "$BRANCH_NAME"
fi
```

### Step 4.2: Navigate to Worktree

```bash
cd ~/git/$REPO_NAME/"$BRANCH_NAME"
```

Verify correct branch:

```bash
git branch --show-current
# Must match the PR's branch name
```

### Step 4.3: Attempt the Merge

```bash
git merge origin/main --no-edit
```

**Three possible outcomes:**

1. **"Already up to date"**: No changes needed. Record as CLEAN. Done.
2. **Clean merge (no conflicts)**: Go to Step 4.5.
3. **Merge conflict**: Go to Step 4.4.

### Step 4.4: Resolve Conflicts (If Any)

List conflicted files:

```bash
git diff --name-only --diff-filter=U
```

For each conflicted file, resolve it:

1. Read the file to see conflict markers:

   ```text
   <<<<<<< HEAD
   (this PR's version)
   =======
   (main's version)
   >>>>>>> origin/main
   ```

2. Understand BOTH versions before making changes.

3. Resolve by combining intelligently:

   | Scenario | Resolution |
   | -------- | ---------- |
   | Both added different things | Keep BOTH additions |
   | Both modified same thing | Combine intent of BOTH |
   | One is a bug fix | Always include the fix |
   | One is a refactor | Apply refactor, then add other changes |
   | Truly incompatible | Prefer PR's changes, add comment explaining |

4. Remove ALL conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`).

5. Stage the resolved file:

   ```bash
   git add <filename>
   ```

After all conflicts resolved:

```bash
git commit --no-edit
```

Record which files were resolved for the subagent's report.

### Step 4.5: Push the Updated Branch

```bash
git push origin $BRANCH_NAME
```

### Step 4.6: Report Result

Each subagent returns:

- PR number
- Branch name
- Status: CLEAN / CONFLICTS_RESOLVED / FAILED
- Files with conflicts (if any)

### Step 5: Wait for All Subagents

Use TaskOutput to wait for all subagents to complete:

```bash
# For each launched subagent, use TaskOutput with the task ID
# Collect all results for final report compilation
```

### Step 6: Clean Up Worktrees (Optional)

If worktrees were created just for this sync:

```bash
git worktree remove ~/git/$REPO_NAME/$BRANCH_NAME
git worktree prune
```

**Note**: Keep worktrees that existed before this command.

### Step 7: Final Report

Print a summary in this format:

```text
## Sync Main into All PRs - Results

Repository: <owner>/<repo>
Main synced to: <commit-sha>
PRs processed: <total-count>

### Clean Merges (<count>)
- PR #<number>: <title>
- PR #<number>: <title>

### Conflicts Resolved (<count>)
- PR #<number>: <title>
  - Files resolved: <file1>, <file2>
- PR #<number>: <title>
  - Files resolved: <file1>

### Failed (<count>)
- PR #<number>: <title>
  - Error: <reason>

### Needs Human Review (<count>)
- PR #<number>: <title>
  - Reason: <why it needs review>
```

## Conflict Resolution Rules

**NEVER do these:**

- Do NOT run `git checkout --theirs <file>` blindly
- Do NOT run `git checkout --ours <file>` blindly
- Do NOT assume "newer is better"
- Do NOT delete one side without understanding both

**ALWAYS do these:**

- Read BOTH versions before resolving
- Understand what each side was trying to accomplish
- Combine changes when possible
- Test or lint resolved files if possible

## Batching for Large Numbers of PRs

If there are more than 10 open PRs:

1. Process PRs 1-10 first
2. Report interim results
3. Process PRs 11-20
4. Continue until all processed

## Error Handling

| Error | Cause | Action |
| ----- | ----- | ------ |
| "merge conflict" | Divergent changes | Follow Step 4.4 |
| "cannot create worktree" | Branch doesn't exist | Fetch first, then retry |
| "push rejected" | Remote has newer changes | Pull, re-merge, then push |
| "permission denied" | Auth issue | Report and skip this PR |

If a PR fails completely:

- Log the error
- Mark as FAILED in the report
- Continue with other PRs
- Do NOT let one failure block everything

## Sequential Execution (Fallback)

Use sequential execution ONLY when parallel execution is not possible:

**When to use sequential:**

- Debugging a specific PR merge issue
- Limited system resources
- Explicit user request

**Sequential approach:**

- Process PRs one at a time following Steps 4.1-4.6
- Complete each PR fully before moving to the next
- Slower but uses less resources

**Note**: Parallel execution (Step 4) is the recommended default approach per the repository style guide.

## Example Usage

```bash
# From any directory in the repo
/sync-main-all
```

This will:

1. Update main from remote
2. Find all open PRs
3. Merge main into each PR branch
4. Resolve conflicts intelligently
5. Push updated branches
6. Report results
