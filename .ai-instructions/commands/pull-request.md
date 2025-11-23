# Task: Pull Request Management

<!-- markdownlint-disable-file MD013 -->

Complete workflow for creating, monitoring, and fixing a pull request (PR) until it is ready to merge.

## 1. Create the Pull Request

**Prerequisites**:

1. **Verify Working Directory is Clean**: Run `git status` - output should show `working tree clean`.
2. **Push Local Branch to Remote**: `git push -u origin $(git branch --show-current)`

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

**Wait 1 Minute After Pushing**: Always wait 1 minute after pushing changes to allow AI reviewers to process updates before checking for feedback.

**Set the PR to Auto-Merge:** `gh pr merge <PR_URL_OR_ID> --rebase --auto`

## 2. PR Resolution Loop

Repeatedly check and fix the PR until mergeable.

### 2.1. PR Health Check

Check status: `gh pr view <PR_URL_OR_ID> --json state,mergeable,statusCheckRollup,reviews,comments`

Requirements:

- `state`: Must be `OPEN`
- `mergeable`: Must be `MERGEABLE`
- `statusCheckRollup.state`: Must be `SUCCESS`
- No unresolved feedback

### 2.2. Fix Failed Checks

1. **Identify Failed Checks**: `gh pr checks <PR_URL_OR_ID>`
2. **View Logs**: `gh run view <run_url> --log`
   > **Note**: The `gh pr checks` command from the previous step provides the `<run_url>` for each check, which can be used directly.
3. **Fix and Push**: Fix the root cause, commit the change with a clear message, and push.
4. **Wait for CI**: `gh pr checks <PR_URL_OR_ID> --watch` - must wait for checks to complete before restarting loop.
5. **Restart Loop**: Return to 2.1.

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

**CRITICAL:** All conversations must be marked "resolved" before PR merge.

**See [pull-request-review-feedback.md](pull-request-review-feedback.md) for complete instructions.**

#### Step 1: Get ALL Review Conversations

```bash
gh api graphql --field query='
{
  repository(owner: "$OWNER", name: "$REPO") {
    pullRequest(number: $PR_NUMBER) {
      reviewThreads(first: 50) {
        nodes {
          id
          isResolved
          comments(first: 10) {
            nodes { id body path line }
          }
        }
      }
    }
  }
}'
```

#### Step 2: Resolve Individual Conversations (after fixing issues)

```bash
gh api graphql --field query='
mutation {
  resolveReviewThread(input: {threadId: "$THREAD_ID"}) {
    thread { id isResolved }
  }
}'
```

**IMPORTANT:** Only resolve conversations after fixing the underlying issues. Never suppress linters - always fix root causes.

### 2.5. Address All Feedback

**List**: `gh pr view <PR_URL_OR_ID> --json reviews,comments`

**Address**:

- If correct: Fix, commit, push, and reply referencing your commit.
- If incorrect: Reply with explanation.

**Restart Loop**: Return to 2.1.

## 3. Final Merge

Once all checks pass and feedback is resolved, the PR will merge automatically.
