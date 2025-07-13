# Task: Pull Request Management

This task outlines the complete, systematic workflow for creating, monitoring, and fixing a pull request (PR) until it is ready to merge.

## 1. Create the Pull Request

1.1. **Create the PR**: Use the `gh pr create` command with a detailed title and body.
1.2. **Set Auto-Merge**: Immediately after creating the PR, set it to auto-merge. This is a mandatory step.

    ```bash
    gh pr merge <PR_URL_OR_ID> --rebase --auto
    ```

## 2. Begin the PR Resolution Loop

You must now repeatedly check and fix the PR until it is in a mergeable state. This is a mandatory, cyclical process.

### 2.1. Run the PR Health Check

Start every loop by getting the complete status of the PR.

    gh pr view <PR_URL_OR_ID> --json state,mergeable,statusCheckRollup,reviews,comments

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

### 2.4. Triage and Address All Feedback

If the Health Check shows pending reviews or open comments:

2.4.1. **List All Feedback**: Use the following command to get every review and comment.

**TODO:** Ignore GitHub "outdated" comments and conversations.

    ```bash
    gh pr view <PR_URL_OR_ID> --json reviews,comments --jq '.reviews, .comments'
    ```

2.4.2. **Address Each Piece of Feedback**:
    - **If the feedback is correct**: Fix the code, commit, and push. Then, reply to the comment referencing your commit.
    - **If the feedback is incorrect**: Reply to the comment with a clear explanation.

        ```bash
        gh pr comment <PR_URL_OR_ID> --body "Replying to review: [Your explanation here]"
        ```

2.4.3. **Resolve Formal Review Threads**: If the feedback was part of a formal review, find the thread ID and resolve it after addressing it.

    ```bash
    # This command is complex; use it to find unresolved thread IDs
    gh api graphql -f query='query($owner: String!, $repo: String!, $pr: Int!) { repository(owner: $owner, name: $repo) {
      pullRequest(number: $pr) { reviewThreads(first: 50) { nodes { id, isResolved } } } } }' \
      -f owner='<OWNER>' -f repo='<REPO>' -F pr=<PR_NUMBER> |
    jq '.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved | not) | .id'

    # Use the ID to resolve the thread
    gh api graphql -f query='mutation($threadId: ID!) {
      resolveReviewThread(input: {threadId: $threadId}) { clientMutationId } }' -f threadId='<THREAD_ID>'
    ```

2.4.4. **Restart the Loop**: Go back to **Step 2.1**.

## 3. Final Merge

Once the "PR Health Check" (Step 2.1) shows that all checks are passing, the PR is mergeable, and all feedback is resolved,
the PR will merge automatically. Your work is complete.
