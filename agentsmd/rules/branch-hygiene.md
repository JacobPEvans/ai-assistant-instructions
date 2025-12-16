# Branch Hygiene

Rules for keeping branches synchronized with main.

## Related Documentation

- [Worktrees](./worktrees.md) - Worktree structure and usage

## Core Principle

The `main` branch must be regularly pulled and kept current. Feature branches should be rebased from main frequently to avoid drift and merge conflicts.

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

## Syncing Workflow

```bash
# From any worktree, sync main first
cd ~/git/<repo>/main
git pull

# Then in your feature worktree
cd ~/git/<repo>/feat/my-feature
git fetch
git rebase origin/main  # or git merge origin/main
```

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
