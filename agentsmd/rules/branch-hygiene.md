# Branch Hygiene

Rules for keeping branches synchronized with main.

## Related Documentation

- [Worktrees](./worktrees.md) - Worktree structure and usage
- [Merge Conflict Resolution](./merge-conflict-resolution.md) - How to resolve conflicts properly

## Core Principle

The `main` branch must be regularly pulled and kept current. Feature branches should be merged with main frequently to avoid drift and merge conflicts.

## Requirements

### Before Starting New Work

1. Always create new worktrees from a synced main (see [Worktrees](./worktrees.md))
2. Never start work from a stale main - this causes painful merge conflicts later

### During Development

1. **Sync main daily**: `cd ~/git/<repo>/main && git pull`
2. **Long-running branches**: Rebase from main at least weekly
3. **Periodic cleanup**: Remove stale worktrees whose branches are merged

### Before Creating PRs

1. Ensure your branch is based on latest main
2. If behind, rebase: `git fetch && git rebase origin/main`
3. Resolve any conflicts before pushing

## Syncing Main Worktree

**CRITICAL**: Always sync main before merging into feature branches.

```bash
# Navigate to main worktree
cd ~/git/<repo>/main

# Fetch latest from remote
git fetch origin main

# Pull latest changes
git pull origin main

# Verify main is current
git log -1 --oneline
```

This ensures all downstream merges use truly current main, not stale data.

## Merging Main Into Feature Branches

After syncing main, update your feature branch:

```bash
# Switch to feature worktree
cd ~/git/<repo>/feat/my-feature

# Merge main into your branch
git merge origin/main --no-edit

# If conflicts occur, see Merge Conflict Resolution guide
# After resolving conflicts
git push origin <branch-name>
```

### Rebase vs Merge

| Method | When to Use |
| ------ | ----------- |
| `git merge origin/main` | Default - preserves history, safer |
| `git rebase origin/main` | Clean linear history - only if you haven't pushed yet |

**Rule**: If your branch has been pushed and reviewed, use merge. Rebase rewrites history and can confuse reviewers.

## Why This Matters

- Stale branches accumulate conflicts exponentially
- CI runs against latest main - your PR may break if main moved
- Code review is harder when diffs include unrelated main changes
- Merge commits pollute history when avoidable

## Git Commands Reference

| Command | Purpose |
| ------- | ------- |
| `git pull` (in main/) | Updates main branch locally |
| `git fetch` | Updates refs without changing working tree |
| `git rebase origin/main` | Replays your commits on latest main |
| `git worktree add` | Creates a new worktree (see [Worktrees](./worktrees.md)) |
| `git worktree remove` | Removes a stale worktree |
| `git worktree prune` | Cleans up worktree administrative files |

## Anti-Patterns

- Working on the same branch for weeks without syncing
- Creating branches from other feature branches (always branch from main)
- Ignoring merge conflict warnings in CI
- Force-pushing after others have reviewed (loses context)
