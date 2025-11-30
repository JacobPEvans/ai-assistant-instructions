# Task: Pull Request Management

<!-- markdownlint-disable-file MD013 -->

Complete workflow for creating, monitoring, and fixing a pull request (PR) until it is ready to merge.

## Critical Rules

1. **NEVER use auto-merge.** Always wait for explicit user approval.
2. **ALL checks must pass.** Never merge with failed checks, even if they appear to be infrastructure issues.
3. **ALL review conversations must be resolved.** Address every piece of feedback.
4. **Run all validation locally before pushing.** This includes linters, formatters, and pre-commit hooks.
5. **User must approve the merge.** After all checks pass and reviews are addressed, request user review.

## 1. Create the Pull Request

**Prerequisites**:

1. **Run Local Validation First**: Before pushing, run all applicable checks locally:
   - `markdownlint-cli2 .` for markdown files (REQUIRED)
   - `terraform fmt -check` and `terraform validate` for Terraform
   - Any project-specific linters or formatters
2. **Verify Working Directory is Clean**: Run `git status` - output should show `working tree clean`.
3. **Push Local Branch to Remote**: `git push -u origin $(git branch --show-current)`

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

**Wait for CI**: After pushing, wait for all CI checks to start: `gh pr checks <PR_URL_OR_ID> --watch`

## 2. PR Resolution Loop

Repeatedly check and fix the PR until ALL requirements are met.

### 2.1. PR Health Check

Check status: `gh pr view <PR_URL_OR_ID> --json state,mergeable,statusCheckRollup,reviews,comments`

**ALL of these must be true:**

- `state`: Must be `OPEN`
- `mergeable`: Must be `MERGEABLE`
- `statusCheckRollup`: ALL checks must show `SUCCESS` (no exceptions)
- All review conversations must be resolved

### 2.2. Fix Failed Checks

**NEVER skip or ignore failed checks.** Even if a check appears to be an infrastructure issue, investigate and fix it.

1. **Identify Failed Checks**: `gh pr checks <PR_URL_OR_ID>`
2. **View Logs**: `gh run view <run_url> --log`
3. **Fix Locally First**: Reproduce and fix the issue locally before pushing.
4. **Run Local Validation**: Re-run all local checks to verify the fix.
5. **Commit and Push**: Commit with a clear message describing the fix.
6. **Wait for CI**: `gh pr checks <PR_URL_OR_ID> --watch` - wait for ALL checks to complete.
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
- `pull_request_review_id`: ID of the review this comment belongs to

**Respond**: `gh pr comment <PR_NUMBER> --body "Addressed in commit <COMMIT_HASH>."`

### 2.4. Resolve PR Conversations

**CRITICAL:** ALL conversations must be marked "resolved" before requesting merge.

```bash
# Get all review threads (replace OWNER, REPO, PR_NUMBER)
gh api graphql -f query='{
  repository(owner: "OWNER", name: "REPO") {
    pullRequest(number: 123) {
      reviewThreads(first: 50) {
        nodes { id isResolved comments(first: 5) { nodes { body path line } } }
      }
    }
  }
}'

# Resolve a thread (use the PRRT_ id from above)
gh api graphql -f query='mutation {
  resolveReviewThread(input: {threadId: "PRRT_xxx"}) {
    thread { isResolved }
  }
}'
```

**See [pull-request-review-feedback.md](pull-request-review-feedback.md) for batch scripts and troubleshooting.**

### 2.5. Address All Feedback

**List**: `gh pr view <PR_URL_OR_ID> --json reviews,comments`

**Address every piece of feedback**:

- If correct: Fix, commit, push, and reply referencing your commit.
- If incorrect: Reply with detailed explanation of why.

**Restart Loop**: Return to 2.1.

## 3. Request User Review and Merge

**ONLY after ALL of the following are true:**

- [ ] All CI checks pass (no exceptions)
- [ ] All review conversations resolved
- [ ] All feedback addressed
- [ ] PR is in `MERGEABLE` state

**Request user approval:**

> "PR is ready for review. All checks pass and all conversations are resolved. Please review and merge when ready."

**Merge Strategy** (user performs the merge):

- **Squash merge**: For small, single-concept changes (`gh pr merge --squash`)
- **Rebase merge**: For larger changes or multiple logical commits (`gh pr merge --rebase`)
