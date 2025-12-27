---
title: "Git Rebase Workflow for Pull Requests"
description: "Local rebase-merge workflow for pull requests with linear git history and signed commits. Rebases PR onto main and pushes to origin/main."
version: "1.0.0"
author: "JacobPEvans"
---

Local rebase workflow for merging pull requests that maintains linear history with signed commits by rebasing PR branches onto main and
pushing directly to origin/main (auto-closing the pull request).

## Why This Workflow?

GitHub's `gh pr merge` command **does not sign commits**, making it incompatible with repositories requiring commit signatures.
This workflow uses local git operations to preserve commit signing throughout the entire merge process.

## When to Use

Use this workflow when:

- You want linear git history for your pull request (no merge commits)
- Your pull request is approved and CI passes
- You need signed commits (required for most repositories)
- You prefer local control over GitHub's merge buttons

Do NOT use when:

- You need to preserve merge commits for audit trail
- Multiple contributors are pushing to your PR branch
- Pull request doesn't require commit signatures

## Critical Requirements for Pull Request Merging

1. **All PR checks must pass** - Never merge a pull request with failed CI
2. **All review threads must be resolved** - Not just addressed, RESOLVED
3. **Pull request must be approved** (unless review not required)
4. **Local main must be synced** - Stale main causes non-fast-forward errors
5. **Commits must be signed** - Required for repositories with signing policies (this is why we can't use `gh pr merge`)

---

## Pull Request Merge-Readiness Criteria

**This is the canonical source of truth for pull request merge-readiness validation.**

A pull request is **READY TO MERGE** when ALL of:

1. `state == "OPEN"` - Pull request is open
2. `mergeable == "MERGEABLE"` - No merge conflicts with base branch
3. `statusCheckRollup.state == "SUCCESS"` - All CI checks pass on the pull request
4. All `reviewThreads` have `isResolved == true` - All pull request review conversations resolved
5. `reviewDecision == "APPROVED"` or `null` - Pull request approved or review not required

A pull request is **BLOCKED** when ANY of:

- `mergeable == "CONFLICTING"` → "pull request has merge conflicts"
- `statusCheckRollup.state != "SUCCESS"` → "pull request CI failing: {checks}"
- Unresolved review threads exist → "pull request has unresolved review comments"
- `reviewDecision == "CHANGES_REQUESTED"` → "pull request reviewer requested changes"

---

## Phase 1: Validate Pull Request Is Ready

### 1.1 Get Current Branch and Pull Request Number

```bash
# Get current branch
BRANCH=$(git branch --show-current)

# Get pull request number for current branch
PR_NUMBER=$(gh pr view --json number --jq '.number')
```

**If no pull request exists**: ABORT with message "No pull request found for branch. Create a pull request first: gh pr create"

### 1.2 Get Repository Information

```bash
# Get owner and repo name
OWNER=$(gh repo view --json owner --jq '.owner.login')
REPO=$(gh repo view --json name --jq '.name')
```

### 1.3 Check PR Mergeable Status

Use the **[GitHub GraphQL Skill](../../../../skills/github-graphql/SKILL.md)** patterns:

```bash
<!-- markdownlint-disable-next-line MD013 -->
gh api graphql --raw-field 'query=query { repository(owner: "'"$OWNER"'", name: "'"$REPO"'") { pullRequest(number: '"$PR_NUMBER"') { state mergeable statusCheckRollup { state } reviewDecision reviewThreads(last: 100) { nodes { isResolved } } } } }'
```

**Validation Requirements** (ALL must pass):

| Field | Required Value | Abort Message |
| ----- | -------------- | ------------- |
| `state` | `OPEN` | "PR is not open (state: {state})" |
| `mergeable` | `MERGEABLE` | "PR has merge conflicts. Resolve before rebasing." |
| `statusCheckRollup.state` | `SUCCESS` | "CI checks have not passed. Wait for green CI." |
| `reviewDecision` | `APPROVED` or `null` | "PR requires approval. Get review first." |
| All `reviewThreads.nodes[].isResolved` | `true` | "Unresolved review threads. Resolve all conversations." |

### 1.4 Verify Unresolved Threads Count

```bash
<!-- markdownlint-disable-next-line MD013 -->
gh api graphql --raw-field 'query=query { repository(owner: "'"$OWNER"'", name: "'"$REPO"'") { pullRequest(number: '"$PR_NUMBER"') { reviewThreads(last: 100) { nodes { isResolved } } } } }' | jq '[.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false)] | length'
```

**If count > 0**: ABORT with "X unresolved review threads remain. Use /resolve-pr-review-thread first."

---

## Phase 2: Sync Local Main with Origin

### 2.1 Find Main Worktree

From **[Worktrees](../../../../rules/worktrees.md)** structure:

```bash
# Get repo name from remote URL
REPO_NAME=$(basename -s .git $(git config --get remote.origin.url))
MAIN_WORKTREE="$HOME/git/$REPO_NAME/main"

# Verify it exists
if [ ! -d "$MAIN_WORKTREE" ]; then
  echo "Main worktree not found at $MAIN_WORKTREE"
  exit 1
fi
```

### 2.2 Fetch and Pull Main

Pattern from **[Sync Main](../../../../commands/sync-main.md)** lines 68-79:

```bash
# Use subshell to update main worktree
(
  cd "$MAIN_WORKTREE"
  git fetch origin main
  git pull origin main
  echo "Main worktree updated. Latest commit:"
  git log -1 --oneline
)
```

### 2.3 Verify Main Is Current

```bash
MAIN_SHA=$(cd "$MAIN_WORKTREE" && git rev-parse --short HEAD)
echo "Local main now at: $MAIN_SHA"
```

---

## Phase 3: Rebase Feature Branch onto Main

### 3.1 Start Rebase

```bash
git rebase main
```

**Three possible outcomes**:

1. **Success** - Continue to Phase 4
2. **Conflicts** - See Conflict Resolution below
3. **Already up-to-date** - Continue to Phase 4

### 3.2 Handle Rebase Conflicts

If conflicts occur, list them:

```bash
# List conflicted files
git diff --name-only --diff-filter=U
```

For each conflicted file, apply intelligent resolution from
**[Merge Conflict Resolution](../../../../rules/merge-conflict-resolution.md)**:

| Scenario | Resolution |
| -------- | ---------- |
| Changes are additive | Keep BOTH changes |
| Changes modify same logic | Combine the intent of both |
| One is a bug fix | Always include the fix |
| One is a refactor | Apply refactor, then add the other change |
| Truly incompatible | Mark for manual resolution |

**Resolution process**:

```bash
# For each conflicted file:
# 1. Read the file to understand both sides
# 2. Edit to resolve intelligently
# 3. Stage the resolved file
git add <resolved-file>

# After all conflicts resolved
git rebase --continue
```

**If conflicts are too complex**:

```bash
git rebase --abort
```

ABORT with:

```text
Rebase conflicts require manual resolution.

To resolve:
1. Run: git rebase main
2. Review each conflict and resolve intelligently
3. Stage resolved files: git add <file>
4. Continue: git rebase --continue
5. Try /rebase-merge again
```

### 3.3 Verify Rebase Success

```bash
# Check for ongoing rebase
if [ -d "$(git rev-parse --git-dir)/rebase-merge" ] || [ -d "$(git rev-parse --git-dir)/rebase-apply" ]; then
  echo "Rebase still in progress"
  exit 1
fi

# Verify branch is ahead of main
COMMITS_AHEAD=$(git log main..HEAD --oneline | wc -l)
echo "Branch is $COMMITS_AHEAD commits ahead of main"
```

---

## Phase 4: Fast-Forward Merge to Main

### 4.1 Switch to Main Worktree

```bash
cd "$MAIN_WORKTREE"
```

### 4.2 Verify Fast-Forward Is Possible

```bash
# Check if feature branch is directly ahead of main
git merge-base --is-ancestor main "$BRANCH"
if [ $? -ne 0 ]; then
  echo "Cannot fast-forward: main has diverged"
  exit 1
fi
```

### 4.3 Perform Fast-Forward Merge

```bash
git merge --ff-only "$BRANCH"
```

**If fast-forward fails**, ABORT with:

```text
Cannot fast-forward merge. Main has diverged since rebase.

This usually means:
1. Someone pushed to main during your rebase
2. Run: git fetch origin main
3. Return to your worktree and run: git rebase origin/main
4. Try /rebase-merge again
```

### 4.4 Verify Merge

```bash
git log -3 --oneline
echo "Main now includes: $(git log -1 --format='%s')"
```

---

## Phase 5: Push to Origin/Main

### 5.1 Push Main to Origin

```bash
git push origin main
```

**This automatically closes the pull request** because the PR's commits (with signatures) are now on main.

**Note on Commit Signing**: All commits retain their signatures through the rebase process.
This is critical for repositories with signing requirements and is why we use this local workflow instead of `gh pr merge`.

### 5.2 Verify Push Success

```bash
git fetch origin main
LOCAL=$(git rev-parse main)
REMOTE=$(git rev-parse origin/main)

if [ "$LOCAL" = "$REMOTE" ]; then
  echo "Push successful. Origin/main updated."
else
  echo "Push failed. Local and remote differ."
  exit 1
fi
```

### 5.3 Verify Pull Request Closed

```bash
PR_STATE=$(gh pr view "$PR_NUMBER" --json state --jq '.state')
echo "Pull request state: $PR_STATE"
```

**Expected**: `MERGED` (GitHub detects commits now on main and auto-closes the pull request)

---

## Phase 6: Cleanup

### 6.1 Return to Original Worktree

```bash
# Get back to the feature worktree before deletion
SAFE_BRANCH=$(printf '%s' "$BRANCH" | tr -c 'A-Za-z0-9._-/' '_')
FEATURE_WORKTREE="$HOME/git/$REPO_NAME/$SAFE_BRANCH"
```

### 6.2 Delete Local Feature Branch

From main worktree:

```bash
git branch -d "$BRANCH"
```

**If fails** (not fully merged):

```bash
# Force delete only if PR is verified merged
if [ "$PR_STATE" = "MERGED" ]; then
  git branch -D "$BRANCH"
fi
```

### 6.3 Delete Remote Feature Branch

```bash
git push origin --delete "$BRANCH" 2>/dev/null || echo "Remote branch already deleted"
```

### 6.4 Remove Worktree

Pattern from **[Sync Main](../../../../commands/sync-main.md)** lines 183-188:

```bash
if [ -d "$FEATURE_WORKTREE" ]; then
  git worktree remove "$FEATURE_WORKTREE"
  echo "Removed worktree: $FEATURE_WORKTREE"
fi

git worktree prune
```

### 6.5 Final Status

```bash
git status
git log -5 --oneline origin/main
```

---

## Edge Cases

### Pull Request Not Found

**Detection**: `gh pr view` returns error

**Action**: ABORT with "No pull request found for current branch. Create a pull request first: gh pr create"

### Pull Request Not Mergeable (Conflicts)

**Detection**: `mergeable == CONFLICTING`

**Action**: ABORT with "Pull request has conflicts with main. Resolve conflicts in the PR first using /sync-main"

### Pull Request CI Still Running

**Detection**: `statusCheckRollup.state == PENDING`

**Action**: ABORT with "Pull request CI checks still running. Wait for completion before merging."

### Pull Request CI Failing

**Detection**: `statusCheckRollup.state == FAILURE`

**Action**: ABORT with "Pull request CI checks are failing. Fix CI issues first using /fix-pr-ci"

### Pull Request Review Not Approved

**Detection**: `reviewDecision == CHANGES_REQUESTED`

**Action**: ABORT with "Pull request reviewer requested changes. Address feedback first."

### Pull Request Has Unresolved Review Threads

**Detection**: Any `reviewThreads[].isResolved == false`

**Action**: ABORT with "Pull request has unresolved review threads. Use /resolve-pr-review-thread first."

### Pull Request Already Merged

**Detection**: `state == MERGED`

**Action**: Skip gracefully with "Pull request already merged. Cleaning up local and remote branches..."

Then proceed to Phase 6 cleanup only.

### Non-Fast-Forward After Rebase

**Detection**: `git merge --ff-only` fails

**Action**: ABORT with instructions (see Phase 4.3)

### Worktree In Use

**Detection**: `git worktree remove` fails

**Action**: Warn but continue:

```text
Warning: Could not remove worktree (may be in use).
Manual cleanup required: git worktree remove <path>
```

### Main Worktree Not Found

**Detection**: Main worktree directory doesn't exist

**Action**: ABORT with:

```text
Main worktree not found at ~/git/<repo>/main

This repository may not be using worktree structure.
See /init-worktree to set up proper worktree structure.
```

---

## Summary Output Template

```text
## Rebase Merge Complete

PR: #<number> - <title>
Branch: <branch-name>
Method: Local rebase + fast-forward push

### Actions Taken

1. ✅ Validated PR: OPEN, MERGEABLE, CI SUCCESS, APPROVED
2. ✅ Synced main: <old-sha> → <new-sha>
3. ✅ Rebased branch: <commits> commit(s)
4. ✅ Fast-forward merged to main
5. ✅ Pushed to origin/main
6. ✅ PR auto-closed by GitHub

### Cleanup

- Deleted local branch: <branch>
- Deleted remote branch: origin/<branch>
- Removed worktree: <path>

### Result

Main branch now at: <commit-sha>
Linear history preserved ✨
```

---

## Anti-Patterns

| Wrong | Right |
| ----- | ----- |
| `git push --force origin main` | Never force push to main |
| Merge without checking CI | Always verify all checks pass |
| Skip thread resolution check | All threads must be marked resolved |
| Rebase when others are pushing to branch | Coordinate with team first |
| Delete branch before verifying merge | Confirm PR state is MERGED |
| Use `git checkout --theirs` blindly | Analyze and combine both sides |

---

## Commands Using This Skill

- `/rebase-merge` - Primary consumer

## Other Commands Referencing This Skill

- `/ready-player-one` - Uses merge-readiness criteria
- `/git-refresh` - References merge-readiness criteria

## Related Resources

- [GitHub GraphQL Skill](../../../../skills/github-graphql/SKILL.md) - PR validation queries
- [Merge Conflict Resolution](../../../../rules/merge-conflict-resolution.md) - Conflict handling patterns
- [Branch Hygiene](../../../../rules/branch-hygiene.md) - Rebase vs merge guidance
- [Worktrees](../../../../rules/worktrees.md) - Worktree structure and cleanup
- [Sync Main](../../../../commands/sync-main.md) - Main sync patterns
