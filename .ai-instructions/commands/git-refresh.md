---
description: Merge current branch's PR (if mergeable) then sync local repo
model: haiku
allowed-tools: Bash(git fetch:*), Bash(git branch:*), Bash(git checkout:*), Bash(git switch:*), Bash(git pull:*), Bash(git log:*), Bash(gh pr view:*), Bash(gh pr merge:*), Bash(gh pr list:*)
---

# Git Refresh

Merge the current branch's pull request (if one exists and is mergeable), then sync the local repository.

## Steps

### 1. Pre-Refresh: Merge Current Branch's PR (If Applicable)

If currently on a feature branch (not main/master/develop):

1.1. **Store the current branch name**:

```bash
CURRENT_BRANCH=$(git branch --show-current)
```

1.2. **Check for open PR**:

```bash
# For branches pushed to origin (default remote)
PR_NUMBER=$(gh pr list --head "$CURRENT_BRANCH" --state open --json number --jq '.[0].number')

# For branches pushed to a fork (replace <username>)
# PR_NUMBER=$(gh pr list --head <username>:"$CURRENT_BRANCH" --state open --json number --jq '.[0].number')
```

1.3. **If a PR exists, check mergeability**:

```bash
if [ -n "$PR_NUMBER" ]; then
  gh pr view "$PR_NUMBER" --json mergeable,statusCheckRollup,state,reviewDecision
fi
```

Verify ALL of these conditions:

- `state`: Must be `OPEN`
- `mergeable`: Must be `MERGEABLE`
- `statusCheckRollup`: ALL checks must show `SUCCESS` (no exceptions)
- `reviewDecision`: Must be `APPROVED` if reviews are required

1.4. **If mergeable, determine merge strategy** using the following criteria:

- **Squash merge** (recommended when all apply):
  - The PR contains a small number of commits (typically 1-3).
  - All commits are closely related and represent incremental progress toward a single outcome.
  - The change can be summarized in 1-2 lines of release notes.
  - The PR affects a single subsystem or feature.
  - **Examples**: Fixing a typo, refactoring a function, adding a small feature.

- **Rebase merge** (recommended when any apply):
  - The PR contains multiple logically independent commits (typically more than 3).
  - Commits represent distinct steps that should be preserved in history.
  - The PR changes multiple subsystems or features.
  - The commit history provides important context for future debugging.
  - **Examples**: Large refactor across modules, feature with preparatory commits.

The goal is a clean, meaningful history. When in doubt, prefer squash for simple changes and rebase for complex, multi-part changes.

1.5. **Merge with appropriate strategy**:

```bash
# Squash merge
gh pr merge "$PR_NUMBER" --squash --delete-branch

# OR Rebase merge
gh pr merge "$PR_NUMBER" --rebase --delete-branch
```

1.6. **If NOT mergeable**: Skip to the sync workflow (Phase 2). This is expected behavior when checks are pending or reviews are required.

> **Note on quick-mergeable branches**: Even if GitHub allows direct pushes to `main` for
> very small changes (such as typo fixes or single config changes), **project policy
> strictly forbids direct commits to `main`**. All changes, no matter how trivial, must
> go through a pull request. This ensures an audit trail and triggers CI validation.

### 2. Sync Workflow

This phase always runs.

2.1. **Store the original branch name** (if not already stored):

```bash
ORIGINAL_BRANCH=$(git branch --show-current)
```

2.2. **Fetch from all remotes and prune deleted remote branches**:

```bash
git fetch --all --prune
```

2.3. **Switch to the default branch** (main or master):

```bash
git checkout main || git checkout master
```

2.4. **Pull the latest changes from origin**:

```bash
git pull origin "$(git branch --show-current)"
```

2.5. **Delete local branches that have been merged** into the default branch:

```bash
git branch --merged | grep -v -E '^\*|main|master|develop' | xargs -r git branch -d
```

- Never delete: main, master, develop
- Report which branches were cleaned up

2.6. **Return to original branch** (if it still exists):

```bash
if git show-ref --verify --quiet "refs/heads/$ORIGINAL_BRANCH"; then
  git checkout "$ORIGINAL_BRANCH"
fi
```

- If the original branch was deleted (locally and/or remotely) as part of the merge and cleanup steps, remain on the default branch.

Provide a brief summary of what changed.

## Merge Messages and Release Notes

For squash merges, the merge commit message should:

- Follow Conventional Commits format: `type(scope): concise description`
- Focus on the user-facing outcome or benefit
- Be suitable for direct inclusion in CHANGELOG.md

Good merge messages describe the outcome:

- `feat(auth): improve user onboarding with passwordless login`
- `fix(api): prevent service degradation during traffic spikes`
- `docs(readme): help new users avoid setup errors`

The PR title typically becomes the squash merge message. Ensure PR titles follow Conventional Commits format for clean release note generation.
