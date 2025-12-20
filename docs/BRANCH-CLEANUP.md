# Branch Cleanup Guide

## Overview

This document describes the `cleanup-stale-branches.sh` script and workflow for safely removing merged branches from the repository.

## Problem

Feature and fix branches accumulate over time. After PRs are merged,
the branch is often left in the repository, creating clutter and confusion.
This is especially problematic in repositories with many contributors and
automated branch creation.

## Solution

The `cleanup-stale-branches.sh` script identifies branches that have been merged and are safe to delete, then provides an option to delete them safely.

## Script Features

- **GitHub API Integration**: Uses `gh` CLI to query merged and open PRs
- **Safety First**: Dry-run mode (default) shows what would be deleted without making changes
- **Open PR Protection**: Never deletes branches that have active PRs
- **Flexible Deletion**: Supports local-only, remote-only, or both
- **Exclusion List**: Preserve important branches (main, master, develop, etc.)

## Usage

### View Branches to Delete (Dry-Run)

```bash
bash scripts/cleanup-stale-branches.sh
```

This will show:

- Merged branches that are safe to delete
- Branches with open PRs (preserved)
- Count of each

Example output:

```text
Analyzing branches for safe deletion...

Merged branches safe to delete (102):
========================================
fix/update-all-symlinks-to-agentsmd
fix/readme-command-count
feat/issue-90-pr-review-guidance
... (more branches)

To apply these deletions, run:
  bash scripts/cleanup-stale-branches.sh --apply
```

### Apply Deletions

To actually delete the identified branches:

```bash
bash scripts/cleanup-stale-branches.sh --apply
```

This will:

1. Delete local branches (if they exist)
2. Delete remote branches via `git push origin --delete`
3. Report success/failure for each branch

### Options

#### `--local-only`

Only delete local branches, not remote:

```bash
bash scripts/cleanup-stale-branches.sh --local-only --apply
```

#### `--remote-only`

Only delete remote branches, not local:

```bash
bash scripts/cleanup-stale-branches.sh --remote-only --apply
```

#### `--exclude=<branches>`

Preserve specific branches (comma-separated):

```bash
bash scripts/cleanup-stale-branches.sh --exclude=feat/important,fix/critical --apply
```

## How It Works

### 1. Identify Merged PRs

The script queries GitHub to find all merged PRs:

```bash
gh pr list --state merged --limit 100 --json headRefName
```

This gives us the branch names of all PRs that have been merged to main.

### 2. Check for Open PRs

The script also queries for open PRs:

```bash
gh pr list --state open --json headRefName
```

Any branch with an open PR is preserved (not deleted).

### 3. Determine Safe Deletions

Branches are marked for deletion if:

- They are in the merged PR list
- They do NOT have an open PR
- They are not in the excluded list

### 4. Delete if Requested

When `--apply` is used, the script:

1. Deletes each local branch with `git branch -d <branch>`
2. Deletes each remote branch with `git push origin --delete <branch>`
3. Reports success/failure for each

## Safety Considerations

### What's Protected

- **Main branch**: Never deleted
- **Default branches**: master, develop, develop are excluded
- **Branches with open PRs**: Always preserved
- **Configuration**: Easy to add custom excluded branches

### What's Checked

The script only deletes branches that:

- Have been merged (verified via GitHub API)
- Don't have active PRs
- Exist as remote tracking branches or local branches
- Are not in the excluded list

### Recovery

If you accidentally delete a branch:

1. **Local branch**: Use git reflog to recover

   ```bash
   git reflog show <branch>
   git branch <branch> <sha>
   ```

2. **Remote branch**: The branch is still on GitHub until garbage collection runs (takes weeks)

   ```bash
   git push origin +<sha>:refs/heads/<branch>
   ```

## Integration with Cleanup Issue #110

This script implements the automated cleanup workflow described in Issue #110. The issue identified these stale branches as needing removal:

- `fix/update-all-symlinks-to-agentsmd` (PR #106)
- `fix/readme-command-count` (PR #102)
- `feat/issue-90-pr-review-guidance` (PR #99)

The script now handles these and identifies 100+ additional stale branches that should be cleaned up.

## Prerequisites

- bash 4.0+
- git
- GitHub CLI (`gh`) configured with authentication

## Examples

### Example 1: Dry-run to see what would be deleted

```bash
$ bash scripts/cleanup-stale-branches.sh

Analyzing branches for safe deletion...

Merged branches safe to delete (102):
========================================
fix/update-all-symlinks-to-agentsmd
fix/readme-command-count
feat/issue-90-pr-review-guidance
...
```

### Example 2: Actually delete all stale branches

```bash
$ bash scripts/cleanup-stale-branches.sh --apply

Analyzing branches for safe deletion...

Merged branches safe to delete (102):
========================================
...

Deleting 102 branches...

  ✓ Deleted local: fix/update-all-symlinks-to-agentsmd
  ✓ Deleted remote: origin/fix/update-all-symlinks-to-agentsmd
  ✓ Deleted local: fix/readme-command-count
  ✓ Deleted remote: origin/fix/readme-command-count
  ...

Cleanup summary:
  Successfully deleted: 102 branches
```

### Example 3: Only delete remote branches, preserve locally

```bash
bash scripts/cleanup-stale-branches.sh --remote-only --apply
```

### Example 4: Preserve specific branches

```bash
bash scripts/cleanup-stale-branches.sh --exclude=feat/important-wip,fix/critical-bug --apply
```

## Automation Opportunities

This script can be integrated into CI/CD workflows to automatically clean up branches:

```bash
# Weekly cleanup via GitHub Actions
name: Cleanup Stale Branches
on:
  schedule:
    - cron: '0 0 * * 0'  # Weekly

jobs:
  cleanup:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: |
          bash scripts/cleanup-stale-branches.sh --apply
```

## Troubleshooting

### Script shows branches but `--apply` fails

**Cause**: You may not have push permissions or the branch may be protected.

**Solution**:

- Check branch protection rules in GitHub
- Verify your GitHub token has `repo` scope
- Try deleting locally first with `--local-only`

### "Cannot delete" errors

**Cause**: Branch may have unpushed commits or protection rules.

**Solution**:

- Check `git log` for unpushed commits
- Review branch protection rules in GitHub settings
- Use `--exclude` to skip problematic branches

### Script doesn't find merged branches

**Cause**: GitHub API query may not have permission or timeout.

**Solution**:

- Verify `gh` is authenticated: `gh auth status`
- Check internet connectivity
- Try increasing the `--limit` parameter in the script

## Contributing

If you find issues or have improvements:

1. Test the script in dry-run mode first
2. Report specific branches that cause issues
3. Suggest improvements to the exclusion logic
4. Contribute tests for edge cases

## Related Documentation

- [Git Branch Hygiene](../agentsmd/rules/branch-hygiene.md)
- [Worktrees](../agentsmd/rules/worktrees.md)
- [Issue #110](https://github.com/JacobPEvans/ai-assistant-instructions/issues/110)
