---
description: Merge main into all open PRs in the current repository with intelligent conflict resolution
model: opus
author: JacobPEvans
allowed-tools: Task, TaskOutput, TodoWrite, Bash(gh:*), Bash(git:*), Read, Write, Edit, Glob, Grep
---

# Sync PRs with Main

**Purpose**: Merge the latest `main` branch into all open PRs in the **current repository** to keep them up to date, with intelligent conflict resolution.

## Scope

**CURRENT REPOSITORY ONLY** - This command operates on the repository you're currently in.

What this command DOES:

- Sync the main worktree with origin/main
- List all open PRs in the current repository
- Create worktrees for each PR
- Merge main into each PR branch with intelligent conflict resolution
- Push updated branches
- Report results

What this command DOES NOT:

- Cross into other repositories
- Force-push or rewrite history
- Assume "newer is better" for conflicts

## Related Documentation

- [Worktrees](../rules/worktrees.md) - Worktree structure and usage
- [Branch Hygiene](../rules/branch-hygiene.md) - Branch sync requirements
- [Merge Conflict Resolution](../rules/merge-conflict-resolution.md) - How to resolve conflicts properly
- [Subagent Parallelization](../rules/subagent-parallelization.md) - Parallel execution patterns

## Critical: Sync Main First

**BEFORE merging into any PR branches, main MUST be synced.**

```bash
# Navigate to main worktree
cd ~/git/<repo-name>/main

# Fetch and pull latest
git fetch origin main
git pull origin main

# Verify main is up to date
git log -1 --oneline
```

This ensures all PR branches receive the truly latest main, not stale data.

## How It Works

You are the **orchestrator**. You will:

1. Sync the main worktree with origin/main
2. Identify the current repository
3. List all open PRs
4. Create worktrees for each PR
5. Launch parallel subagents per PR to merge main
6. Monitor completion with TaskOutput
7. Handle conflicts intelligently (subagents analyze and resolve)
8. Clean up worktrees
9. Report results

## Execution Steps

### Step 1: Sync Main Worktree

**CRITICAL**: This must happen FIRST.

```bash
# Get repo name and find main worktree
REPO_NAME=$(basename $(git rev-parse --show-toplevel 2>/dev/null || pwd))
MAIN_WORKTREE=~/git/$REPO_NAME/main

# Sync main
cd $MAIN_WORKTREE
git fetch origin main
git pull origin main
```

### Step 2: Identify Repository

```bash
gh repo view --json nameWithOwner --jq '.nameWithOwner'
```

### Step 3: List Open PRs

```bash
gh pr list --json number,headRefName,title,mergeable
```

### Step 4: Create Worktrees

For each PR:

```bash
# Fetch the branch
git fetch origin <branch-name>

# Create worktree
git worktree add ~/git/<repo-name>/<branch-name> <branch-name>
```

### Step 5: Launch Parallel Subagents

Launch ONE subagent per PR in a SINGLE message with multiple Task tool calls.

**Subagent Prompt**:

```text
Merge main into PR #{NUMBER} for {OWNER}/{REPO}

Branch: {BRANCH_NAME}
Worktree: {WORKTREE_PATH}
Title: {PR_TITLE}
Main worktree: ~/git/{REPO_NAME}/main

Your mission:
1. Navigate to the worktree: cd {WORKTREE_PATH}
2. Verify you're on the correct branch: git branch --show-current
3. Attempt merge: git merge origin/main --no-edit
4. If merge succeeds (no conflicts):
   a. Push: git push origin {BRANCH_NAME}
   b. Report success
5. If merge has conflicts:
   a. List conflicted files: git diff --name-only --diff-filter=U
   b. For EACH conflicted file, follow [Merge Conflict Resolution](../rules/merge-conflict-resolution.md)
   c. Stage resolved files: git add <file>
   d. Complete merge: git commit --no-edit
   e. Push: git push origin {BRANCH_NAME}

CRITICAL RULES:
- NEVER just accept "theirs" or "ours" blindly
- NEVER assume newer is better
- ALWAYS analyze both sides before resolving
- If unsure, mark for human review

Report when complete:
✅ PR: https://github.com/{OWNER}/{REPO}/pull/{NUMBER}
✅ Merge status: {SUCCESS/CONFLICTS_RESOLVED/NEEDS_REVIEW}
✅ Conflicts resolved: {N} files (list them)
⚠️ Needs human review: {list or "none"}
```

### Step 6: Monitor Subagents

Wait for all agents to complete using `TaskOutput` with `block=true`.

### Step 7: Clean Up Worktrees

```bash
git worktree remove ~/git/<repo-name>/<branch-name>
git worktree prune
```

### Step 8: Final Report

```text
## Sync PRs with Main Results

Repository: {OWNER}/{REPO}
Main synced to: {COMMIT_SHA}
PRs processed: {N}

✅ CLEAN MERGE ({N} PRs):
- #{NUMBER}: {TITLE} - no conflicts
...

✅ CONFLICTS RESOLVED ({N} PRs):
- #{NUMBER}: {TITLE} - {N} files resolved
...

⚠️ NEEDS HUMAN REVIEW ({N} PRs):
- #{NUMBER}: {TITLE} - {reason}
...

❌ FAILED ({N} PRs):
- #{NUMBER}: {TITLE} - {error}
...

Worktrees cleaned up: {N}
```

## Conflict Resolution

See [Merge Conflict Resolution](../rules/merge-conflict-resolution.md) for detailed guidance on resolving conflicts properly.

## Batching

If > 10 PRs need syncing:

- Process first 10
- Wait for completion
- Process next batch

## Error Handling

If subagent fails on a PR:

- Mark PR as "needs human review"
- Log the issue
- Continue with other PRs
- Don't let one failure block everything

## Example Usage

```bash
# From any worktree in the repo
/sync-prs-with-main
```

The orchestrator will:

1. Sync main worktree first
2. Find all open PRs
3. Create worktrees for each
4. Merge main with intelligent conflict resolution
5. Push updated branches
6. Clean up and report

---

**Remember**: Sync main FIRST, analyze conflicts don't assume, preserve PR intent, incorporate main updates.
