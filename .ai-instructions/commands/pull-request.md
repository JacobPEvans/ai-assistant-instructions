# Task: Pull Request

This task outlines the standards for creating, verifying, and managing pull requests (PRs) to ensure they are ready for merging.

## 1. PR Description Template

All pull requests must use the following template.

```markdown
## Description

[Detailed explanation of the changes and their purpose. Explain the "why," not just the "what." Address the business value or the problem being solved.]

## Changes Made

- [Specific functional change 1]
- [Specific functional change 2]
- [Highlight any security or performance implications]

## Testing Instructions

1.  [Provide clear, step-by-step instructions for reviewers to validate the changes.]
2.  [Include both positive and negative test cases.]
3.  [Specify any required test data or setup.]

## Cost Impact

- [Estimate the monthly cost impact of any cloud resource changes.]
- [Provide justification for any resources costing over $5/month.]

## Related Issues

- Fixes #issue-number
- Addresses #issue-number
```

## 2. Post-Creation Verification (Mandatory)

After creating the PR, you **must** perform the following verification steps. Do not proceed to merge until all conditions are met.

### Step 2.1: Wait for and Verify CI/CD Checks

Automated checks can take time to complete. You must wait for them and ensure they all pass.

**Action:**

- Run `gh pr checks <PR_URL_OR_ID> --watch --interval 60` to monitor the checks.
- This command will watch the checks for the specified PR, refreshing every 60 seconds.
- **Do not proceed** until all required checks are completed and have passed successfully.
  If any check fails, you must analyze the failure and fix the underlying issue.

### Step 2.2: Check for and Resolve All Conversations

A PR is not ready to be merged until all conversations and comments have been addressed.

**Action:**

1.  **Wait for Reviews**: After checks have passed, wait at least 1-2 minutes for any initial reviews to be submitted.
2.  **List Comments and Conversations**: Use the following commands to get a complete picture of all feedback.
    -   To see a summary in the terminal:

        ```bash
        gh pr view <PR_URL_OR_ID> --comments
        ```

    -   For a detailed JSON output of all review comments and threads:

        ```bash
        gh api repos/{owner}/{repo}/pulls/{pr_number}/comments
        ```

    -   For unresolved review threads, which often block merging:

        ```graphql
        query($owner: String!, $repo: String!, $pr: Int!) {
          repository(owner: $owner, name: $repo) {
            pullRequest(number: $pr) {
              reviewThreads(first: 100) {
                nodes {
                  isResolved
                  comments(first: 10) {
                    nodes {
                      author { login }
                      body
                    }
                  }
                }
              }
            }
          }
        }
        ```

3.  **Address All Feedback**: This is **non-negotiable**.
    -   For every piece of feedback, you must either implement the suggested change or provide a clear explanation for why you are not.
    -   No open conversations can remain.

## 3. Merging

Only after all conditions in Step 2 are met can you proceed to merge.

-   **Final Check**: Run `gh pr checks <PR_URL_OR_ID>` one last time.
-   **Merge**: Use `gh pr merge <PR_URL_OR_ID> --merge --delete-branch`.
-   **No Squash Merging**: Preserve the commit history by using a standard merge.
-   **Delete Branch**: The `--delete-branch` flag will remove the branch after a successful merge.
