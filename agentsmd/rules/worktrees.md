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
git worktree add ~/git/<repo-name>/<branch-name> -b <branch-name> main
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
git worktree remove ~/git/<repo-name>/<branch-name>
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

## PR Requirement

Every worktree/branch with commits must have an associated PR.

This is required for auto-claude and all automated workflows:

1. Create worktree with `/init-worktree`
2. Make changes and commit
3. Create PR immediately (before more work)
4. Monitor PR until CI passes and comments resolved
5. Remove worktree after PR is merged

Work is tracked via PRs on GitHub, not local worktrees.

### Why This Matters

- PRs are visible and trackable - branches without PRs are invisible
- PRs can be reviewed, discussed, and approved - branches cannot
- PRs auto-close linked issues - branches do nothing
- Worktrees consume disk space and create confusion

### Verification

A branch is orphaned if:

- It has commits beyond main
- It does NOT have an associated PR

Orphaned branches should either have a PR created immediately or be deleted (if work is abandoned).

## Why Worktrees

- **Isolation**: Each worktree is independent - no accidental cross-contamination
- **Parallel work**: Work on multiple branches simultaneously without stashing
- **Clean state**: Always start from latest main
- **Concurrent sessions**: Multiple AI sessions can work on different branches safely

## Starting Claude Code Sessions

**Always start Claude Code from a worktree directory, not the bare repo root.**

### From Bare Repo Root (Wrong)

Starting Claude from `~/git/<repo>/` causes:

- `git rev-parse --show-toplevel` fails (no working tree)
- `CLAUDE.md` and `AGENTS.md` not loaded into context
- `git status` reports nothing useful
- File operations require absolute paths
- No access to committed files

### From Worktree Directory (Correct)

Starting Claude from `~/git/<repo>/main/` or any feature worktree:

- Full git context available
- `CLAUDE.md` and `AGENTS.md` automatically loaded
- `git status` shows actual working tree state
- All committed files accessible for reading/editing
- Relative paths work as expected

### Recommendation

Before starting Claude Code:

```bash
cd ~/git/<repo>/main/
```

Or for feature work:

```bash
cd ~/git/<repo>/feat/<branch-name>/
```

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

- 1-line documentation typo fixes (e.g., spelling/grammar in comments or markdown) may be on main.
  All code changes, regardless of size, must use a worktree.
- Read-only exploration/research tasks
