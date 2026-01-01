---
description: Merge current branch's PR (if mergeable), sync local repo, and cleanup stale worktrees
model: haiku
allowed-tools: Task, TaskOutput, Bash(gh pr list:*), Bash(gh pr merge:*), Bash(gh pr view:*), Bash(git branch:*), Bash(git checkout:*), Bash(git fetch:*), Bash(git log:*), Bash(git pull:*), Bash(git status:*), Bash(git switch:*), Bash(git worktree list:*), Bash(git worktree prune:*), Bash(git worktree remove:*), Bash(grep:*)
---

# Git Refresh

Merge open PRs (if mergeable), sync the local repository, and cleanup stale worktrees.

## Steps

### 1. Identify PRs to Merge

**CRITICAL**: Always check for open PRs, regardless of current branch.

1.1. Note the current branch name.

1.2. Check for open PRs in TWO ways:

```bash
# If on a feature branch, check for PR from this branch
gh pr view --json state,number,title 2>/dev/null

# ALWAYS also check for any open PRs by the user
gh pr list --author @me --state open --json number,title,headRefName
```

1.3. If any open PRs exist, evaluate each for mergeability.

### 2. Merge Eligible PRs

For each open PR found:

2.1. Check merge status:

```bash
gh pr view NUMBER --json state,mergeable,statusCheckRollup
```

2.2. **Mergeable criteria** - See
**[Git Rebase Workflow Skill](../../.claude/plugins/jpe-git/skills/git-rebase-workflow/SKILL.md#merge-readiness-criteria)**
for canonical validation rules.

Quick summary:

- State is OPEN
- Mergeable is MERGEABLE
- All status checks SUCCESS
- All review threads resolved
- Review decision APPROVED or not required

2.3. If mergeable, use the **[Git Rebase Workflow Skill](../../.claude/plugins/jpe-git/skills/git-rebase-workflow/SKILL.md)** to merge the PR with signed commits.

2.4. If not mergeable, report why and continue to next PR or sync.

> **Note**: All PR merges must use the git rebase workflow to ensure commit signatures are preserved. GitHub's `gh pr merge` does not sign commits.

### 3. Sync Workflow

3.1. Fetch all remotes and prune deleted remote branches.

3.2. Switch to default branch (main or master).

3.3. Pull latest changes.

3.4. Delete local branches already merged into default (never delete main/master/develop).

3.5. If original branch still exists locally, switch back to it. Otherwise stay on default.

### 4. Worktree Cleanup

4.1. List all worktrees:

```bash
git worktree list
```

4.2. For each worktree (excluding the main working directory), check if stale:

```bash
# Check if branch exists locally
git branch --list <branch-name>

# Check if branch exists on remote
git branch -r --list origin/<branch-name>

# Check if branch has been merged into main
git branch --merged main | grep <branch-name>
```

A worktree is stale if its branch no longer exists or has been merged into main.

4.3. Remove stale worktrees (branch merged or deleted):

```bash
git worktree remove /path/to/worktree
```

4.4. Prune worktree administrative files for any manually deleted directories:

```bash
git worktree prune
```

> **Note**: Only remove worktrees whose branches have been merged or deleted.
> Active development worktrees should be preserved.

### 5. Summary

5.1. Verify current state:

```bash
git status
```

5.2. Provide a brief summary including:

- PRs merged (if any)
- Branches cleaned up (if any)
- Worktrees removed (if any)
- Current branch and sync status

## Common Mistake to Avoid

**DO NOT** skip the PR check just because you're on main. The user may have:

- Switched to main after pushing a feature branch
- Multiple open PRs from different branches
- Auto-merge enabled but not yet merged

Always run `gh pr list --author @me --state open` to find work that needs merging.

## Merge Process

All merges follow the local rebase workflow to preserve commit signatures.
See **[Git Rebase Workflow Skill](../../.claude/plugins/jpe-git/skills/git-rebase-workflow/SKILL.md)** for the complete merge process.
