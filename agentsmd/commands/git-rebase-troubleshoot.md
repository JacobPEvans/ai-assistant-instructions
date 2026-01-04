---
description: Troubleshoot and recover from git rebase failures
model: haiku
allowed-tools: Bash(git:*), Bash(gh pr view:*), Bash(gh pr list:*), Read, Grep, Glob
---

# Git Rebase Troubleshoot

Diagnose and recover from `/git-rebase` failures. Only invoke this skill when the primary
`/git-rebase` command encounters errors that the main skill's "EXPECTED ERRORS" section
cannot resolve.

**For generic git/worktree issues**, see:

- `/git-worktree-troubleshooting` - Worktree paths, branch issues, ambiguous refnames
- `/git-precommit-troubleshooting` - Pre-commit hook auto-fixes

---

## Quick Diagnosis

Check: `pwd`, `git status`, `git branch --show-current`, `git worktree list`, `gh pr view`.

For worktree path discovery, see [Worktree Management](../skills/worktree-management/SKILL.md).
For PR commands, see [GitHub CLI Patterns](../skills/github-cli-patterns/SKILL.md).

---

## Error: Push Rejected (Non-Fast-Forward)

Branches diverged. Fix: `git fetch origin && git rebase origin/main && git push origin main`

If fails again, origin/main was updated during rebase - start over from `/git-rebase` Step 1.

---

## Error: Repository Rule Violations

GH013 error about PR/status checks. This is NOT a block if commits are from approved PR.

**Causes**: CI not passing, reviews not approved, merge conflict.

**Fix order**: Rebase feature → push (triggers CI) → wait for checks → merge to main → push.

Check: `gh pr view <branch> --json checks,reviews,statusCheckRollup`

---

## Error: Embedded Git Repository

Nested .git directory found. Fix: `git rm --cached folder` or add to `.gitignore`.

---

## Rebase Conflict

Identify: `git status`, `git diff --name-only --diff-filter=U`

Resolve: edit files, `git add <file>`, then `git rebase --continue` (or `--abort`).

---

## Error: Fast-Forward Merge Failed

Main was updated between rebase and merge.
Get main path (see [Worktree Management](../skills/worktree-management/SKILL.md)).
Run `git fetch origin && git reset --hard origin/main`, then re-run `/git-rebase`.

---

## Error: Feature Branch Push Failed

**Fix**: `git push --force-with-lease origin <branch>`

---

## Recovery: Aborting In-Progress Rebase

`git rebase --abort && git status`

---

## Verification

Verify before retrying:

- Main synced: `cd "$MAIN_PATH" && git diff origin/main --stat` (should be empty)
- Branch clean: `git status`
- No rebase in progress: check `.git/rebase-{merge,apply}` doesn't exist
- PR state: `gh pr view <branch> --json state`

---

## Escalation

If unresolved: check `git reflog`, review `git log -10 --oneline`, ask user.

**DO NOT**: Use `--force` (use `--force-with-lease`), use `gh pr merge`, run `git rebase -i`.
