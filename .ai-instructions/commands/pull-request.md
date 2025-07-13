# Task: Pull Request Management

This task outlines the complete, systematic workflow for creating, monitoring, and fixing a pull request (PR) until it is ready to merge.

## 1. Create the Pull Request

1.1. **Create the PR**: Use the `gh pr create` command with a detailed title and body.
1.2. **Set Auto-Merge**: Immediately after creating the PR, set it to auto-merge. This is a mandatory step.

    ```bash
    gh pr merge <PR_URL_OR_ID> --rebase --auto
    ```

## 2. Begin the PR Resolution Loop

You must now repeatedly check and fix the PR until it is in a mergeable state. Continue this loop until the `gh pr status` command shows all checks passing and all conversations resolved.

### 2.1. Check the PR Status

Use the `gh pr status` command to get a summary of checks and reviews.

### 2.2. Analyze and Fix Failed Checks

2.2.1. **Identify Failed Checks**: Look for any checks with a `✖` status.
2.2.2. **View the Logs**: For each failed check, view the detailed logs to find the error.

    ```bash
    gh run list --workflow=<workflow_file.yml> --branch=<branch_name>
    gh run view <run_id> --log
    ```

2.2.3. **Fix the Code**: Make the necessary code changes to fix the root cause of the failure.
2.2.4. **Commit and Push**: Commit the fix with a clear message and push it to the PR branch. This will re-run the checks.

### 2.3. Analyze and Resolve Conversations

2.3.1. **List Unresolved Conversations**: Use the following command to get the ID, author, and content of all unresolved review threads.

    ```bash
    gh pr view <PR_URL_OR_ID> --json comments,reviews --jq '.reviews[] | .comments.nodes[] | select(.isResolved | not) |
      {id: .id, author: .author.login, body: .body}'
    ```

2.3.2. **Analyze Each Conversation**: For each unresolved conversation:
    - **If the feedback is correct**: Fix the code as requested. Commit and push the changes.
    - **If the feedback is incorrect or you disagree**: Post a reply comment explaining your reasoning.

        ```bash
        gh pr comment <PR_URL_OR_ID> --body "Replying to review: [Your explanation here]"
        ```

2.3.3. **Resolve the Conversation**: After addressing the feedback (by pushing a code fix or replying), resolve the thread using its `id`.

    ```bash
    gh api graphql -f query='
      mutation($threadId: ID!) {
        resolveReviewThread(input: {threadId: $threadId}) {
          thread {
            isResolved
          }
        }
      }' -f threadId='<THREAD_ID>'
    ```

### 2.4. Repeat the Loop

After pushing fixes or resolving conversations, go back to **Step 2.1** and check the status again. Continue this process until the PR is clean.

## 3. Final Merge

Once all checks have passed and all conversations are resolved, the PR will merge automatically. No further action is needed.