# Task: Pull Request

This task outlines the complete, non-negotiable workflow for creating, verifying, and managing pull requests (PRs) to ensure a clean and linear git history.

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

## 2. Create the Pull Request & Set Auto-Merge

Create the PR and immediately set it to auto-merge. This is a mandatory step.

```bash
# Create the pull request
gh pr create --title "<title>" --body-file <path_to_description_file>

# Set auto-merge using the rebase strategy
gh pr merge <PR_URL_OR_ID> --rebase --auto
```

## 3. Post-Creation Verification (Mandatory)

After creating the PR and setting auto-merge, you **must** monitor it and resolve any issues that arise.

### Step 3.1: Wait for and Verify CI/CD Checks

Automated checks can take time to complete. You must wait for them and ensure they all pass.

**Action:**

- Run `gh pr checks <PR_URL_OR_ID> --watch --interval 30` to monitor the checks.
- **Do not proceed** until all required checks are completed and have passed successfully. If any check fails, you must analyze the failure, fix the underlying issue, commit the fix, and push the changes. The watcher will automatically pick up the new checks.

### Step 3.2: Check for and Resolve All Conversations

A PR cannot be merged until all conversations are resolved.

**Action:**

1. **List Conversations**: Use the following GraphQL query to find all unresolved review threads.

    ```bash
    gh api graphql -f query='
      query($owner: String!, $repo: String!, $pr: Int!) {
        repository(owner: $owner, name: $repo) {
          pullRequest(number: $pr) {
            reviewThreads(first: 100) {
              nodes {
                id
                isResolved
              }
            }
          }
        }
      }' -f owner='<OWNER>' -f repo='<REPO>' -F pr=<PR_NUMBER> | \
      jq '.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false)'
    ```

2. **Address Feedback**: For any unresolved threads, you must address the feedback by pushing code changes.
3. **Resolve Threads**: After pushing fixes, programmatically resolve the conversation threads using their `id` from the previous query.

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

## 4. Final Merge

Once all checks have passed and all conversations are resolved, the PR will merge automatically. No further action is needed.
