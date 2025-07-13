# Task: Pull Request Management

<!-- markdownlint-disable-file MD013 -->

This task outlines the complete, systematic workflow for creating, monitoring, and fixing a pull request (PR) until it is ready to merge.

✅ **UPDATE:** The PR conversation resolution system is now fully implemented with working GraphQL queries.

## 1. Create the Pull Request

1.1. **Create the PR**: Use the `gh pr create` command with a detailed title and body.

**PR Description Template:**

```markdown
## Summary
Brief overview of changes made.

## Related PRD
Link to the PRD file created in Step 2: `.tmp/prd-<task-name>.md`

## Testing Instructions
- [ ] Steps to test the changes
- [ ] Expected behavior

## Changes Made
- List of key changes
- Files modified

## Additional Notes
Any other relevant information for reviewers.
```

1.2. **Set Auto-Merge**: Immediately after creating the PR, set it to auto-merge. This is a mandatory step.

```bash
gh pr merge <PR_URL_OR_ID> --rebase --auto
```

## 2. Begin the PR Resolution Loop

You must now repeatedly check and fix the PR until it is in a mergeable state. This is a mandatory, cyclical process.

### 2.1. Run the PR Health Check

Start every loop by getting the complete status of the PR.

```bash
gh pr view <PR_URL_OR_ID> --json state,mergeable,statusCheckRollup,reviews,comments
```

Analyze the output:

- `state`: Must be `OPEN`.
- `mergeable`: Must be `MERGEABLE`.
- `statusCheckRollup`: The `state` field must be `SUCCESS`.
- `reviews` and `comments`: Must have no unresolved feedback.

**If the PR is clean, proceed to Step 3. Otherwise, continue the loop.**

### 2.2. Triage and Fix Failed Checks

If the Health Check shows failing checks:

2.2.1. **Identify Failed Checks**: Use `gh pr checks <PR_URL_OR_ID>` to see which jobs failed.
2.2.2. **View the Logs**: Get the ID of the failed run and view its log.

```bash
# First, get the ID of the latest run for that workflow
gh run list --workflow=<workflow_file.yml> --branch=<branch_name> --limit=1
# Then, view the log
gh run view <run_id> --log
```

2.2.3. **Fix, Commit, and Push**: Fix the root cause of the error, commit the change with a clear message, and push it to the PR branch.
2.2.4. **Wait for CI**: You **must** wait for the new checks to complete before restarting the loop.

```bash
gh pr checks <PR_URL_OR_ID> --watch
```

2.2.5. **Restart the Loop**: Go back to **Step 2.1**.

### 2.3. Read Line-Level Review Comments (Simple Method)

The simplest way to get specific line-level feedback that needs addressing:

```bash
# Get all line-level review comments for your PR (replace placeholders)
gh api repos/<OWNER>/<REPO>/pulls/<PR_NUMBER>/comments

# Example for this repository (PR #22):
gh api repos/JacobPEvans/ai-assistant-instructions/pulls/22/comments
```

This returns an array of review comments with:

- `body`: The comment text and suggested changes
- `path`: File path where comment was made
- `line`: Line number in the file
- `pull_request_review_id`: ID of the review this comment belongs to

**Responding to Comments:**

```bash
# Reply to a specific PR comment
gh pr comment <PR_NUMBER> --body "I have addressed this issue in commit <COMMIT_HASH>."

# Example:
gh pr comment 22 --body "I have addressed this issue in commit f640821."
```

**Wait 1 Minute After Pushing:** Always wait 1 minute after pushing changes to allow AI reviewers to process updates before checking for new feedback.

### 2.4. Resolve PR Conversations (Automated) ✅ WORKING

**✅ FULLY IMPLEMENTED:** The PR conversation resolution system is now working and has been tested successfully.

**CRITICAL:** GitHub requires all conversations to be marked as "resolved" before allowing PR merge. This **must** be automated.

**📋 For complete, detailed instructions with exact working GraphQL queries, see:**
**[pull-request-review-feedback.md](pull-request-review-feedback.md)**

#### Quick Reference: Two-Step Process

**Step 1: Get ALL Review Conversations**
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

**Step 2: Resolve Individual Conversations (after fixing issues)**
```bash
gh api graphql --field query='
mutation {
  resolveReviewThread(input: {threadId: "$THREAD_ID"}) {
    thread { id isResolved }
  }
}'
```

**IMPORTANT:** 
- Only resolve conversations **after** you have actually fixed the underlying issues
- Never suppress linters or quality checks - always fix root causes
- See [pull-request-review-feedback.md](pull-request-review-feedback.md) for complete documentation

### 2.5. Triage and Address All Feedback

If the Health Check shows pending reviews or open comments:

2.5.1. **List All Feedback**: Use the following command to get every review and comment.

**TODO:** Ignore GitHub "outdated" comments and conversations.

```bash
gh pr view <PR_URL_OR_ID> --json reviews,comments --jq '.reviews, .comments'
```

2.5.2. **Address Each Piece of Feedback**:
    - **If the feedback is correct**: Fix the code, commit, and push. Then, reply to the comment referencing your commit.
    - **If the feedback is incorrect**: Reply to the comment with a clear explanation.

```bash
gh pr comment <PR_URL_OR_ID> --body "Replying to review: [Your explanation here]"
```

2.5.3. **Restart the Loop**: Go back to **Step 2.1**.

## 3. Final Merge

Once the "PR Health Check" (Step 2.1) shows that all checks are passing, the PR is mergeable, and all feedback is resolved,
the PR will merge automatically. Your work is complete.
