---
description: Merge current branch's PR (if mergeable) then sync local repo
model: haiku
allowed-tools: Bash(git fetch:*), Bash(git branch:*), Bash(git checkout:*), Bash(git switch:*), Bash(git pull:*), Bash(git log:*), Bash(gh pr view:*), Bash(gh pr merge:*), Bash(gh pr list:*)
---

# Git Refresh

Merge the current branch's pull request (if one exists and is mergeable), then sync the local repository.

## Pre-Refresh: Merge Current Branch's PR (If Applicable)

If the current directory is on a feature branch (not main/master/develop):

1. **Check for open PR**: `gh pr list --head <branch-name> --state open --json number`

2. **If a PR exists, check mergeability**:

   ```bash
   gh pr view <PR_NUMBER> --json mergeable,statusCheckRollup,state
   ```

   - All checks must pass (SUCCESS status)
   - PR must be in MERGEABLE state
   - PR must be OPEN

3. **If mergeable, determine merge strategy** based on change complexity:
   - **Squash merge**: For semantically simple changes that can be described
     fully in 1-2 lines of release notes. Typically single-concept changes,
     small fixes, or focused refactors where commits represent incremental
     progress toward a single outcome.
   - **Rebase merge**: For complex changes with multiple logical commits that
     should be preserved individually. Changes that span multiple concepts
     or require detailed commit history for understanding.

   Use judgment: The goal is clean, meaningful history that reads well in
   release notes and git log.

4. **Merge with appropriate strategy**:
   - Squash: `gh pr merge --squash --delete-branch`
   - Rebase: `gh pr merge --rebase --delete-branch`

5. **If NOT mergeable**: Skip to the sync workflow below (no error - this is
   expected behavior when checks are pending or reviews are required).

> **Note on quick-mergeable branches**: For very small changes on non-protected
> branches, GitHub may allow direct pushes to main without a PR. If your
> repository settings permit and the change is trivial (typo fix, single config
> change), you may push directly. However, prefer creating a PR even for small
> changes as it provides an audit trail and triggers CI validation.

## Sync Workflow

1. Note the current branch name (may have changed if PR was just merged)
2. Fetch from all remotes and prune deleted remote branches
3. Switch to the default branch (main or master)
4. Pull the latest changes from origin
5. Delete local branches that have been merged into the default branch
   - Never delete: main, master, develop
   - Report which branches were cleaned up
6. If the original branch still exists (wasn't merged/deleted), switch back to it

Provide a brief summary of what changed.

## Merge Messages and Release Notes

For squash merges, the merge commit message should:

- Follow Conventional Commits format: `type(scope): concise description`
- Summarize the "why" not the "what"
- Be suitable for direct inclusion in CHANGELOG.md

Good merge messages become release notes:

- `feat(auth): add passwordless email login`
- `fix(api): resolve rate limiting under high load`
- `docs(readme): clarify installation prerequisites`

The PR title typically becomes the squash merge message. Ensure PR titles follow
Conventional Commits format for clean release note generation.
