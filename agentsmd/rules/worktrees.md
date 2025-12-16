# Git Worktrees

Authoritative documentation for git worktree structure and usage.

## Core Principle

All development work MUST be done in a dedicated worktree. This ensures isolation between concurrent sessions and prevents accidental changes on main.

## Directory Structure

```text
~/git/<repo-name>/
├── .git/                    # Shared git directory (bare repo)
├── main/                    # Main branch worktree (read-only for development)
├── feat/<branch-name>/      # Feature worktrees
└── fix/<branch-name>/       # Fix worktrees
```

### Key Points

- The repository root (`~/git/<repo-name>/`) contains only `.git/` and worktree subdirectories
- The `main` branch is itself a worktree at `main/`
- All worktrees share one `.git` directory - commits are immediately visible across all
- Each worktree is completely isolated - changes in one don't affect others

## Worktree Naming

| Branch Type | Branch Name | Worktree Path |
| ----------- | ----------- | ------------- |
| Main | `main` | `~/git/<repo>/main/` |
| Feature | `feat/add-feature` | `~/git/<repo>/feat/add-feature/` |
| Fix | `fix/bug-name` | `~/git/<repo>/fix/bug-name/` |

## Creating Worktrees

New worktrees branch off `main`:

```bash
git worktree add ~/git/<repo>/<branch> -b <branch> main
```

Example:

```bash
git worktree add ~/git/ai-assistant-instructions/feat/add-dark-mode -b feat/add-dark-mode main
```

## Listing Worktrees

```bash
git worktree list
```

Example output:

```text
/Users/user/git/ai-assistant-instructions                  (bare)
/Users/user/git/ai-assistant-instructions/main             aa4aa1f [main]
/Users/user/git/ai-assistant-instructions/feat/new-feature  b123456 [feat/new-feature]
```

## Removing Worktrees

Remove when branch is merged or no longer needed:

```bash
git worktree remove ~/git/<repo>/<branch>
```

Clean up stale references:

```bash
git worktree prune
```

## Stale Worktree Criteria

A worktree is stale if ANY of these are true:

- Branch has been merged into main
- Branch no longer exists on remote
- Worktree has no uncommitted changes and PR is merged

## Why Worktrees

- **Isolation**: Each worktree is independent - no accidental cross-contamination
- **Parallel work**: Work on multiple branches simultaneously without stashing
- **Clean state**: Always start from latest main
- **Concurrent sessions**: Multiple AI sessions can work on different branches safely

## Migration from Standard Checkout

If you have an existing repository at `~/git/<repo>/` (standard git checkout):

1. Create a bare clone or convert existing to bare
2. Add `main` as a worktree: `git worktree add main main`
3. Create feature worktrees as needed

The `/init-worktree` command handles this conversion automatically.

## When to Use Worktrees

**Always use a worktree for:**

- New features
- Bug fixes
- Refactoring
- Documentation updates
- Any changes requiring commits

**Skip only for:**

- 1-line typo fixes directly on main (rare exception)
- Read-only exploration/research tasks
