# PR Comment Limits

## Overview

This rule establishes a hard limit of **50 total comments per pull request** to prevent review cycles from becoming unresolvable due to excessive AI-generated feedback.

## Problem Statement

AI review tools (copilot, Claude Code action) can enter infinite loops where they continuously post
new comments on every commit, preventing PRs from ever reaching a merged state.
This rule prevents that scenario by capping feedback at 50 comments.

## The 50-Comment Limit

### What Counts as a Comment

A "comment" includes:

- PR review threads (code review comments in conversation threads)
- Inline code comments (comments on specific lines)
- General PR comments (discussions on the PR body)
- Resolved comments (comments that have been marked resolved still count)

### When the Limit Applies

The 50-comment limit applies to:

- All PR creation and review commands (`/rok-review-pr`, `/pr`, etc.)
- All PR comment resolution workflows
- All AI-generated review mechanisms
- Manual command execution by users on PRs

### What Happens at the Limit

When a PR reaches 50 comments:

1. **New comments are auto-resolved** with a standard message
2. **No new unresolved comments are posted** by AI tools
3. **The message template** (see below) is used to explain the limit
4. **Enforcement is automatic** via GitHub Actions workflow

## Implementation Details

### GraphQL Query: Count PR Comments

Use this query to check the total comment count on a PR:

```bash
gh api graphql -f query='
query {
  repository(owner: "OWNER", name: "REPO") {
    pullRequest(number: PR_NUMBER) {
      comments(first: 1) {
        totalCount
      }
      reviewThreads(first: 100) {
        totalCount
        nodes {
          id
          isResolved
        }
      }
    }
  }
}
' --jq '.data.repository.pullRequest.comments.totalCount + .data.repository.pullRequest.reviewThreads.totalCount'
```

### GraphQL Mutation: Resolve Review Thread

Use this mutation to resolve review threads when comment limit is reached:

```bash
gh api graphql -f query='
mutation {
  resolveReviewThread(input: {threadId: "THREAD_ID"}) {
    thread {
      id
      isResolved
    }
  }
}'
```

## Auto-Resolution Message Template

When auto-resolving comments due to the 50-comment limit, use this message:

```text
This PR has reached the 50-comment limit. All subsequent comments are being
automatically resolved to allow the PR to be merged. Please address any
critical feedback on a follow-up PR.
```

## Commands: Pre-Comment Check

Before posting any new comments on a PR, commands should:

1. **Check comment count**:

   ```bash
   comment_count=$(gh api graphql -f query='...' --jq '...')
   ```

2. **If >= 50**:
   - Do NOT post new comments
   - Log that the limit has been reached
   - Exit gracefully with a message explaining the limit

3. **If < 50**:
   - Proceed with posting comments as normal

## Workflows: Enforcement

GitHub Actions workflows enforce this limit:

1. **Trigger**: Only on PR creation (`pull_request: [opened]`)
   - NOT on subsequent commits (`synchronize`)
   - NOT on ready_for_review, reopened, or other events

2. **Behavior**:
   - Check comment count on workflow start
   - If >= 50: Resolve any unresolved threads with the standard message
   - If < 50: Proceed with normal workflow logic

## References

- **Related Rule**: `subagent-parallelization.md` for batching strategies
- **Related Command**: `rok-review-pr.md` - References this rule
- **Related Command**: `rok-resolve-pr-review-thread.md` - Respects this limit
- **Related Workflow**: `pr-comment-limit-check.yml` - Enforces this rule

## Examples

### Example 1: PR with 45 comments

- Workflow runs normally
- Commands can post new comments (< 50 limit)
- No auto-resolution triggered

### Example 2: PR with 50+ comments

- Workflow runs on PR creation
- Any unresolved threads are auto-resolved
- Auto-resolution message is posted
- Commands skip posting new comments and exit early

### Example 3: PR that accumulates comments over time

- If PR is reopened or receives new commits
- Workflow only re-checks on PR reopening (not on new commits)
- If limit exceeded, auto-resolution takes effect again

## FAQ

**Q: Why count resolved comments?**
A: Resolved comments still take up space in the review conversation and can make merging confusing.
Counting them prevents gaming the system by just resolving old comments to post new ones.

**Q: What if a comment is truly important after 50?**
A: Critical issues should be addressed in a follow-up PR after the current one is merged.
The limit exists to prevent infinite review cycles.

**Q: Can I disable the limit for specific PRs?**
A: Not currently. The 50-comment limit applies uniformly to prevent workarounds.
If a PR legitimately needs more feedback, it should be split into smaller PRs.

**Q: Why 50 and not some other number?**
A: 50 is a reasonable threshold that allows for comprehensive feedback while preventing infinite loops.
It can be adjusted if experience shows a different limit is more appropriate.

## Rationale

1. **Prevents Infinite Loops**: Caps AI feedback to prevent endless comment cycles
2. **Forces Prioritization**: Limited space forces AI tools to post only the most important feedback
3. **Supports Merging**: Allows PRs to eventually reach a merged state
4. **DRY Compliance**: Single rule referenced by all commands and workflows
5. **Transparent**: Clear message explains why auto-resolution is happening

---

**Status**: Active
**Last Updated**: 2025-12-17
**Applies To**: All PR operations across all commands and workflows
