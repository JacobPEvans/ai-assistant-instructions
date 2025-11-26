# Snippets: GitHub GraphQL Queries

Tested, working GraphQL queries for GitHub API operations.

## Variables

- `$OWNER` - Repository owner (e.g., "JacobPEvans")
- `$REPO` - Repository name
- `$PR_NUMBER` - PR number (integer, no quotes)
- `$THREAD_ID` - Thread ID (starts with `PRRT_`)

## Get Review Threads

```bash
gh api graphql -f query='
{
  repository(owner: "$OWNER", name: "$REPO") {
    pullRequest(number: $PR_NUMBER) {
      reviewThreads(first: 50) {
        nodes {
          id
          isResolved
          comments(first: 10) {
            nodes { body path line }
          }
        }
      }
    }
  }
}'
```

## Resolve Thread

```bash
gh api graphql -f query='
mutation {
  resolveReviewThread(input: {threadId: "$THREAD_ID"}) {
    thread { id isResolved }
  }
}'
```

## Get Unresolved Thread IDs

```bash
gh api graphql -f query='...' | jq -r \
  '.data.repository.pullRequest.reviewThreads.nodes[]
   | select(.isResolved == false) | .id'
```

## Batch Resolve

```bash
for id in $UNRESOLVED_IDS; do
  gh api graphql -f query="
  mutation {
    resolveReviewThread(input: {threadId: \"$id\"}) {
      thread { id isResolved }
    }
  }"
done
```

## Get PR Status

```bash
gh api graphql -f query='
{
  repository(owner: "$OWNER", name: "$REPO") {
    pullRequest(number: $PR_NUMBER) {
      title state mergeable
      reviews(first: 20) { nodes { state } }
    }
  }
}'
```

## REST Alternative

```bash
gh api repos/$OWNER/$REPO/pulls/$PR_NUMBER/comments
```
