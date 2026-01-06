---
description: Rebase feature branch onto main and push to origin
model: haiku
author: JacobPEvans
allowed-tools: Bash(git:*), Bash(gh:*)
---

# Git Rebase

Push `<branch>` commits to `origin/main`.

```text
feature-branch ──rebase──> main ──push──> origin/main → PR auto-closes
```

**SUCCESS**: Task complete when `git push origin main` succeeds and PR shows MERGED.

## Prerequisites

1. PR exists: `gh pr view <branch> --json state`
2. No ambiguous refs: `git show-ref origin/main` (1 line only)
3. Discover paths via `git worktree list` (use the worktree-management skill)

**Note**: This command works regardless of local folder naming. Paths are discovered via `git worktree list`,
and remote operations use git metadata (origin URL), not directory names.

## Four Steps

```bash
# Step 1: Update main
cd <MAIN_PATH> && git fetch origin && git reset --hard origin/main

# Step 2: Rebase branch (if conflicts: /git-rebase-troubleshoot)
cd <BRANCH_PATH> && git rebase main

# Step 3: Push branch & merge
cd <BRANCH_PATH> && git push --force-with-lease origin <branch>
cd <MAIN_PATH> && git merge --ff-only <branch>

# Step 4: PUSH MAIN TO ORIGIN (THE WHOLE POINT)
cd <MAIN_PATH> && git push origin main
```

## Expected Errors (DO NOT GIVE UP)

### Non-fast-forward

origin/main has commits you don't have.

```bash
cd <MAIN_PATH>
git fetch origin && git rebase origin/main && git push origin main
```

If fails: origin updated while you worked. Start over from Step 1.

### Repository rule violations

Status checks may be failing.

```bash
gh pr view <branch> --json checks,reviews
cd <BRANCH_PATH> && git push --force-with-lease origin <branch>
# Wait for checks, then:
cd <MAIN_PATH> && git merge --ff-only <branch> && git push origin main
```

**NEVER use `gh pr merge`** - bypasses commit signing.

### Pre-commit modified files

See `/git-precommit-troubleshooting` or:

```bash
cd <MAIN_PATH>
git add -A && git commit --amend --no-edit && git push origin main
```

### Ambiguous refname

```bash
git branch -D origin/main  # Delete local branch
```

See `/git-worktree-troubleshooting` for details.

## Verify

```bash
cd <MAIN_PATH>
git fetch origin
test "$(git rev-parse HEAD)" = "$(git rev-parse origin/main)" && echo "✓ Success"
gh pr view <branch> --json state   # Should show MERGED
```

## Key Rules

- NEVER stop after rebase - must push main
- NEVER stop on error - read and fix it
- NEVER use `--force` (use `--force-with-lease`)
- NEVER use `gh pr merge`
- NEVER report success until origin/main updated AND PR merged

## Troubleshooting

If stuck: `/git-rebase-troubleshoot`
