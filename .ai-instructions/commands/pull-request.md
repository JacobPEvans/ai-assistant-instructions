---
description: Complete workflow for creating, monitoring, and fixing pull requests until ready to merge
allowed-tools: Read, Bash(git:*), Bash(gh:*), Bash(markdownlint-cli2:*)
author: JacobPEvans
---

# Task: Pull Request Management

<!-- markdownlint-disable-file MD013 -->

Complete workflow for creating, monitoring, and fixing a pull request (PR) until it is ready to merge.

## Critical Rules

1. **NEVER use auto-merge.** Always wait for explicit user approval.
2. **ALL checks must pass.** Never merge with failed checks, even if they appear to be infrastructure issues.
3. **ALL review conversations must be PHYSICALLY RESOLVED.** Not just addressed - marked as resolved in GitHub.
4. **Run all validation locally before pushing.** This includes linters, formatters, and pre-commit hooks.
5. **User must approve the merge.** Only request user review AFTER all checks pass AND all conversations are resolved.
6. **ALWAYS commit, push, and create PR when work is complete.** Do not ask the user if they want a PR - create it automatically. This kicks off automated reviews and gives users a single place to view all changes.
7. **ALWAYS watch CI checks after PR creation.** Run `gh pr checks --watch` as a background task for the first 60 seconds to catch quick failures. Fix any issues before returning to the user.

## Useful Watch Commands

These commands block and wait for completion - use them instead of polling:

```bash
# Watch all PR checks until they complete (recommended)
gh pr checks <PR_NUMBER> --watch

# Watch a specific workflow run
gh run watch <RUN_ID>

# Watch with custom interval (seconds)
gh pr checks <PR_NUMBER> --watch --interval 5

# Exit immediately on first failure
gh pr checks <PR_NUMBER> --watch --fail-fast
```

## 1. Create the Pull Request

**Prerequisites**:

1. **Run Local Validation First**: Before pushing, run all applicable checks locally:
   - `markdownlint-cli2 .` for markdown files (REQUIRED)
   - `terraform fmt -check` and `terraform validate` for Terraform
   - Any project-specific linters or formatters
2. **Verify Working Directory is Clean**: Run `git status` - output should show `working tree clean`.
3. **Push Local Branch to Remote**: `git push -u origin $(git branch --show-current)`
4. **Link to Related Issue**: If this PR implements a GitHub issue:
   - Ensure branch name includes issue number (e.g., `feature/issue-123-description`)
   - Add `Closes #issue-number` to PR description
   - After PR creation, comment on the issue: `gh issue comment {issue} --body "Implementation PR: #{pr}"`

**PR Description Template:**

```markdown
## Summary
Brief overview of changes made.

## Related PRD
Link to the PRD file: `.tmp/prd-<task-name>.md`

## Testing Instructions
- [ ] Steps to test the changes
- [ ] Expected behavior

## Changes Made
- List of key changes

## Additional Notes
Any other relevant information for reviewers.
```

**Wait for CI**: `gh pr checks <PR_NUMBER> --watch`

## 2. PR Resolution Loop

Repeatedly check and fix the PR until ALL requirements are met.

### 2.1. PR Health Check

Check status: `gh pr view <PR_NUMBER> --json state,mergeable,statusCheckRollup,reviews,comments`

**ALL of these must be true:**

- `state`: Must be `OPEN`
- `mergeable`: Must be `MERGEABLE`
- `statusCheckRollup`: ALL checks must show `SUCCESS` (no exceptions)
- All review conversations must be resolved (verified via GraphQL)

### 2.2. Fix Failed Checks

**NEVER skip or ignore failed checks.** Even if a check appears to be an infrastructure issue, investigate and fix it.

1. **Identify Failed Checks**: `gh pr checks <PR_NUMBER>`
2. **View Logs**: `gh run view <RUN_ID> --log`
3. **Fix Locally First**: Reproduce and fix the issue locally before pushing.
4. **Run Local Validation**: Re-run all local checks to verify the fix.
5. **Commit and Push**: Commit with a clear message describing the fix.
6. **Wait for CI**: `gh pr checks <PR_NUMBER> --watch`
7. **Restart Loop**: Return to 2.1.

### 2.3. Read Line-Level Review Comments

Get line-level feedback:

```bash
gh api repos/<OWNER>/<REPO>/pulls/<PR_NUMBER>/comments
```

Returns an array of review comments with:

- `body`: The comment text and suggested changes
- `path`: File path where comment was made
- `line`: Line number in the file

### 2.4. Resolve PR Conversations

> **🚨 STRICT BLOCKER**: ALL conversations must be PHYSICALLY MARKED AS RESOLVED in GitHub before requesting user review. This is not optional. Do NOT return control to the user until every conversation shows `isResolved: true`.

#### Step 1: Get all review threads

```bash
gh api graphql -f query='{
  repository(owner: "OWNER", name: "REPO") {
    pullRequest(number: 123) {
      reviewThreads(first: 50) {
        nodes { id isResolved comments(first: 5) { nodes { body path line } } }
      }
    }
  }
}'
```

#### Step 2: For each unresolved thread, fix the issue then resolve it

```bash
gh api graphql -f query='mutation {
  resolveReviewThread(input: {threadId: "PRRT_xxx"}) {
    thread { isResolved }
  }
}'
```

#### Step 3: Verify ALL threads are resolved

```bash
# Must return ZERO unresolved threads
gh api graphql -f query='{
  repository(owner: "OWNER", name: "REPO") {
    pullRequest(number: 123) {
      reviewThreads(first: 50) {
        nodes { id isResolved }
      }
    }
  }
}' | jq '.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false)'
```

If the above command returns ANY output, there are still unresolved conversations. **DO NOT proceed to Step 3.**

**See [pull-request-review-feedback.md](pull-request-review-feedback.md) for batch resolution scripts.**

### 2.5. Address All Feedback

**List**: `gh pr view <PR_NUMBER> --json reviews,comments`

**Address every piece of feedback**:

- If correct: Fix, commit, push, and resolve the conversation.
- If incorrect: Reply with explanation, then resolve the conversation.

**Restart Loop**: Return to 2.1.

## 3. Pre-Handoff Verification

**Before requesting user review, verify ALL of the following:**

```bash
# 1. All checks pass
gh pr checks <PR_NUMBER>
# Must show ALL checks as "pass"

# 2. All conversations resolved
gh api graphql -f query='{
  repository(owner: "OWNER", name: "REPO") {
    pullRequest(number: 123) {
      reviewThreads(first: 50) {
        nodes { isResolved }
      }
    }
  }
}' | jq '[.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false)] | length'
# Must return 0

# 3. PR is mergeable
gh pr view <PR_NUMBER> --json mergeable
# Must show "MERGEABLE"
```

**Only if ALL three verifications pass**, request user review:

> "PR #XX is ready for your review. All checks pass, all conversations are resolved, and the PR is mergeable. Please review and merge when ready."

## 4. Merge (User Action)

The user performs the merge:

- **Squash merge**: For small, single-concept changes (`gh pr merge --squash`)
- **Rebase merge**: For larger changes or multiple logical commits (`gh pr merge --rebase`)
