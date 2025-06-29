# Task: Pull Request

This task outlines the standards for creating and managing pull requests (PRs), ensuring they are clear, comprehensive, and easy to review.

## PR Description Template

All pull requests must use the following template.

```markdown
## Description

[Detailed explanation of the changes and their purpose. Explain the "why," not just the "what." Address the business value or the problem being solved.]

## Changes Made

- [Specific functional change 1]
- [Specific functional change 2]
- [Highlight any security or performance implications]

## Testing Instructions

1. [Provide clear, step-by-step instructions for reviewers to validate the changes.]
2. [Include both positive and negative test cases.]
3. [Specify any required test data or setup.]

## Cost Impact

- [Estimate the monthly cost impact of any cloud resource changes.]
- [Provide justification for any resources costing over $5/month.]

## Related Issues

- Fixes #issue-number
- Addresses #issue-number
```

## Review Process

- **Self-Review**: Review your own code first before assigning reviewers.
- **Address All Comments**: **This is non-negotiable.** Every comment left by a reviewer must be addressed. You must either implement the suggested change or explain why you are not making the change and resolve the comment.
- **Resolve All Conversations**: No open conversations can remain before merging.

## Merging

- **Automated Checks**: All CI/CD checks must pass.
- **Approval**: At least one reviewer must approve the PR.
- **No Squash Merging**: Preserve the commit history by using a standard merge.
- **Delete Branch**: Delete the feature branch after merging.