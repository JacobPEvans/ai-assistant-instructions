---
description: How to programmatically resolve PR review threads using GitHub's GraphQL API
model: haiku
author: JacobPEvans
allowed-tools:
  # Core tools (required for all commands)
  - Task
  - TaskOutput
  - TodoWrite
  # GitHub CLI
  - Bash(gh:*)
---

# Resolving PR Review Conversations

<!-- markdownlint-disable-file MD013 -->

How to programmatically resolve PR review threads using GitHub's GraphQL API.

> **PR Comment Limit**: All operations in this guide respect the **50-comment limit per PR** defined in the [PR Comment Limits rule](../rules/pr-comment-limits.md). When resolving threads, if a PR has reached 50 comments, no new comments should be posted.

## Quick Reference

```bash
# 1. Get all review threads
gh api graphql -f query='{
  repository(owner: "OWNER", name: "REPO") {
    pullRequest(number: 123) {
      reviewThreads(first: 50) {
        nodes { id isResolved comments(first: 5) { nodes { body path line } } }
      }
    }
  }
}'

# 2. Resolve a single thread
gh api graphql -f query='mutation {
  resolveReviewThread(input: {threadId: "PRRT_xxx"}) {
    thread { id isResolved }
  }
}'
```

## Complete Working Example

This is exactly what was used to resolve 7 threads on PR #29:

### Step 1: Get All Threads

```bash
gh api graphql -f query='
{
  repository(owner: "JacobPEvans", name: "ai-assistant-instructions") {
    pullRequest(number: 29) {
      reviewThreads(first: 50) {
        nodes {
          id
          isResolved
          comments(first: 5) {
            nodes { body path line }
          }
        }
      }
    }
  }
}'
```

**Response (abbreviated):**

```json
{
  "data": {
    "repository": {
      "pullRequest": {
        "reviewThreads": {
          "nodes": [
            {
              "id": "PRRT_kwDOO1m-OM5gtgeQ",
              "isResolved": false,
              "comments": {
                "nodes": [
                  {
                    "body": "Consider adding back Pre-Commit Validation...",
                    "path": "agentsmd/commands/pr.md",
                    "line": 16
                  }
                ]
              }
            },
            {
              "id": "PRRT_kwDOO1m-OM5gtged",
              "isResolved": false,
              "comments": {
                "nodes": [
                  {
                    "body": "The removed 'Review, Don't Chat' rule was important...",
                    "path": "agentsmd/workflows/4-implement-and-verify.md",
                    "line": 10
                  }
                ]
              }
            }
          ]
        }
      }
    }
  }
}
```

### Step 2: Resolve Each Thread

**Single thread:**

```bash
gh api graphql -f query='
mutation {
  resolveReviewThread(input: {threadId: "PRRT_kwDOO1m-OM5gtged"}) {
    thread { id isResolved }
  }
}'
```

**Response:**

```json
{
  "data": {
    "resolveReviewThread": {
      "thread": {
        "id": "PRRT_kwDOO1m-OM5gtged",
        "isResolved": true
      }
    }
  }
}
```

**Multiple threads (use parallel execution or batch queries):**

Instead of sequential loops, use `xargs` with `-P` for parallel execution:

```bash
# Resolve multiple threads in parallel
echo -e "PRRT_kwDOO1m-OM5gtgeQ\nPRRT_kwDOO1m-OM5gtgtP\nPRRT_kwDOO1m-OM5gtgtb" | \
  xargs -I {} bash -c '
    gh api graphql -f threadId="{}" -f query="
    mutation(\$threadId: String!) {
      resolveReviewThread(input: {threadId: \$threadId}) {
        thread { id isResolved }
      }
    }" && echo "✓ Resolved {}"
  '
```

## Key Points

1. **Thread IDs start with `PRRT_`** - This is how you identify them in the response.

2. **Use `-f query=` not `--field query=`** - Both work, but `-f` is shorter.

3. **Quote escaping in loops** - When using shell variables, use double quotes for the outer query and escape inner quotes:

   ```bash
   gh api graphql -f query="mutation { resolveReviewThread(input: {threadId: \"$thread_id\"}) { thread { isResolved } } }"
   ```

4. **Only resolve after fixing** - Don't resolve threads just to clear them. Fix the issue first, then resolve.

## Batch Resolution Script

Get unresolved thread IDs and resolve them all using parallel execution:

```bash
# Set these for your PR
OWNER="JacobPEvans"
REPO="ai-assistant-instructions"
PR_NUMBER=29

# Get unresolved thread IDs and resolve them in parallel
gh api graphql -f query="
{
  repository(owner: \"$OWNER\", name: \"$REPO\") {
    pullRequest(number: $PR_NUMBER) {
      reviewThreads(first: 50) {
        nodes { id isResolved }
      }
    }
  }
}" | jq -r '.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false) | .id' | \
  xargs -I {} bash -c '
    gh api graphql -f threadId="{}" -f query="
    mutation(\$threadId: String!) {
      resolveReviewThread(input: {threadId: \$threadId}) {
        thread { id isResolved }
      }
    }" && echo "✓ Resolved {}"
  '
```

## Troubleshooting

| Problem | Solution |
| ------- | -------- |
| Empty response | Check OWNER/REPO/PR_NUMBER are correct |
| Mutation fails | Verify thread ID starts with `PRRT_` |
| Permission denied | Run `gh auth status` to verify authentication |
| Variables not substituting | Use double quotes and escape inner quotes |

## Why This Matters

GitHub's branch protection can require "all conversations resolved" before merge. Without programmatic resolution, autonomous PR management is impossible. This GraphQL approach enables:

- Automated CI/CD pipelines to resolve threads after fixing issues
- AI assistants to fully manage PRs without human intervention
- Batch resolution of multiple threads in one operation
