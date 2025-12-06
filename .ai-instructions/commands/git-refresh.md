---
description: Merge current branch's PR (if mergeable) then sync local repo
model: haiku
allowed-tools: Bash(git fetch:*), Bash(git branch:*), Bash(git checkout:*), Bash(git switch:*), Bash(git pull:*), Bash(git log:*), Bash(gh pr view:*), Bash(gh pr merge:*), Bash(gh pr list:*)
---

# Git Refresh

Merge the current branch's PR (if mergeable), then sync the local repository.

## Steps

### 1. Pre-Refresh: Merge Current Branch's PR (If Applicable)

If currently on a feature branch (not main/master/develop):

1.1. Note the current branch name for later.

1.2. Check if an open PR exists for this branch.

1.3. If a PR exists, verify it's mergeable (open state, all checks passing, approved if required).

1.4. If mergeable, choose merge strategy:

- **Squash**: Simple changes describable in 1-2 release note lines.
- **Rebase**: Complex changes with multiple meaningful commits to preserve.

1.5. Merge and delete the remote branch.

1.6. If not mergeable, skip to sync workflow. This is expected when checks are pending or reviews required.

> **Note**: Project policy requires all changes go through a PR for audit trail and CI validation.

### 2. Sync Workflow

2.1. Note the current branch name (may have changed after merge).

2.2. Fetch all remotes and prune deleted remote branches.

2.3. Switch to default branch (main or master).

2.4. Pull latest changes.

2.5. Delete local branches already merged into default (never delete main/master/develop).

2.6. If original branch still exists, switch back to it. Otherwise stay on default.

Provide a brief summary of what changed.

## Merge Messages

Squash merge messages should follow Conventional Commits format and focus on the outcome.
The PR title becomes the merge message, so ensure it reads well as a release note.
