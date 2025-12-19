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

### Step 4: Create Worktrees for Each PR

For EACH open PR, create a worktree if one doesn't exist:

```bash
# For each PR branch
BRANCH_NAME=<branch-from-step-3>
PR_NUMBER=<number-from-step-3>

# Fetch the branch
git fetch origin $BRANCH_NAME

# Check if worktree already exists
WORKTREE_PATH=~/git/$REPO_NAME/$BRANCH_NAME
if [ -d "$WORKTREE_PATH" ]; then
    echo "Worktree exists: $WORKTREE_PATH"
else
    git worktree add $WORKTREE_PATH $BRANCH_NAME
fi
```

### Step 5: Merge Main into Each PR Branch

For EACH PR, follow these sub-steps:

#### 5.1: Navigate to the PR's Worktree

```bash
cd ~/git/$REPO_NAME/$BRANCH_NAME
```

#### 5.2: Verify Correct Branch

```bash
git branch --show-current
# Must match the PR's branch name
```

#### 5.3: Attempt the Merge

```bash
git merge origin/main --no-edit
```

**Three possible outcomes:**

1. **"Already up to date"**: No changes needed. Record as CLEAN. Go to next PR.
2. **Clean merge (no conflicts)**: Go to Step 5.5.
3. **Merge conflict**: Go to Step 5.4.

#### 5.4: Resolve Conflicts (If Any)

**5.4.1: List conflicted files:**

```bash
git diff --name-only --diff-filter=U
```

**5.4.2: For EACH conflicted file, resolve it:**

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

**5.4.3: After ALL conflicts resolved:**

```bash
git commit --no-edit
```

Record which files were resolved for the final report.

#### 5.5: Push the Updated Branch

```bash
git push origin $BRANCH_NAME
```

#### 5.6: Record Result for This PR

Track the outcome:

- PR number
- Branch name
- Status: CLEAN / CONFLICTS_RESOLVED / FAILED
- Files with conflicts (if any)

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
| "merge conflict" | Divergent changes | Follow Step 5.4 |
| "cannot create worktree" | Branch doesn't exist | Fetch first, then retry |
| "push rejected" | Remote has newer changes | Pull, re-merge, then push |
| "permission denied" | Auth issue | Report and skip this PR |

If a PR fails completely:

- Log the error
- Mark as FAILED in the report
- Continue with other PRs
- Do NOT let one failure block everything

## Parallel Execution (Advanced)

For faster processing with subagents:

- Launch ONE subagent per PR using the Task tool
- Maximum 5 subagents at once to prevent resource exhaustion
- Each subagent follows Steps 5.1-5.6 for its assigned PR
- Orchestrator waits for all to complete with TaskOutput
- Orchestrator compiles final report

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
