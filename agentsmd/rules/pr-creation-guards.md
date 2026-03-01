# PR Creation Guards

**Before running `gh pr create`**, execute these checks in order. They prevent zombie PRs and enforce issue linking.

## Guard 1: Check for Merged Twin (Prevents Zombies)

A zombie PR occurs when a squash-merge deletes the remote branch but leaves the local worktree. Auto-maintain re-pushes, creating a duplicate PR.

```bash
# Check if this branch's work was already squash-merged
gh pr list --repo JacobPEvans/<repo> --state merged --head <current-branch>
```

If a merged PR exists for this branch: **STOP**. Do not create a new PR.
Instead: remove the stale local worktree (`git worktree remove <path>`).

Also check by content similarity — squash-merge creates a new commit, so the branch name won't match:

```bash
gh pr list --repo JacobPEvans/<repo> --state merged --limit 10 --json number,title,headRefName
```

If any merged PR has the same title or describes the same work: **STOP** and clean up.

## Guard 2: Check for Existing Open PR (Prevents Duplicates)

```bash
gh pr list --repo JacobPEvans/<repo> --state open --head <current-branch>
```

If an open PR exists for this branch: push to it instead of creating a new one.

```bash
git push origin <current-branch>
```

## Guard 3: Find Related Issues (Enforces Linking)

```bash
gh issue list --repo JacobPEvans/<repo> --state open --search "<keywords from branch name/commit>"
```

If issues are found: include `Closes #X` or `Related to #X` in the PR body.
After PR creation: comment on the issue with `gh issue comment <num> --body "Implementation: #<pr>"`.

See the issue-pr-linking rule for full bidirectional linking requirements.

## Guard 4: Validate Worktree is Not Stale

Before pushing/creating PR, verify the branch has commits not in main:

```bash
git log origin/main..HEAD --oneline
```

If output is empty: this branch has no new work. Clean up instead of creating a PR.

## Applicability

These guards apply to all PR creation workflows:

- auto-maintain
- finalize-pr / commit-push-pr
- Manual `gh pr create`
- Any automation that creates PRs
