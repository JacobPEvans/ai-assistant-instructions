---
description: Merge current branch's PR (if mergeable) then sync local repo
model: haiku
allowed-tools: Bash(git fetch:*), Bash(git branch:*), Bash(git checkout:*), Bash(git switch:*), Bash(git pull:*), Bash(git log:*), Bash(gh pr view:*), Bash(gh pr merge:*), Bash(gh pr list:*)
---

# Git Refresh

Merge open PRs (if mergeable), then sync the local repository.

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

2.2. **Mergeable criteria**:

- State is OPEN
- Mergeable is MERGEABLE (not CONFLICTING or UNKNOWN)
- Status checks: All completed successfully (ignore skipped checks)

2.3. If mergeable, choose merge strategy:

- **Squash**: Simple changes describable in 1-2 release note lines (default)
- **Rebase**: Complex changes with multiple meaningful commits to preserve

2.4. Merge and delete the remote branch:

```bash
gh pr merge NUMBER --squash --delete-branch
```

2.5. If not mergeable, report why and continue to next PR or sync.

> **Note**: Project policy requires all changes go through a PR for audit trail and CI validation.

### 3. Sync Workflow

3.1. Fetch all remotes and prune deleted remote branches.

3.2. Switch to default branch (main or master).

3.3. Pull latest changes.

3.4. Delete local branches already merged into default (never delete main/master/develop).

3.5. If original branch still exists locally, switch back to it. Otherwise stay on default.

### 4. Summary

Provide a brief summary including:

- PRs merged (if any)
- Branches cleaned up (if any)
- Current branch and sync status

## Common Mistake to Avoid

**DO NOT** skip the PR check just because you're on main. The user may have:

- Switched to main after pushing a feature branch
- Multiple open PRs from different branches
- Auto-merge enabled but not yet merged

Always run `gh pr list --author @me --state open` to find work that needs merging.

## Merge Messages

Squash merge messages should follow Conventional Commits format and focus on the outcome.
The PR title becomes the merge message, so ensure it reads well as a release note.
