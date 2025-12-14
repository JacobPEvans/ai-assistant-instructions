---
title: "Respond to Reviews"
description: "Respond to PR review feedback efficiently with systematic resolution, parallel sub-agents, and GitHub thread resolution"
model: opus
type: "command"
version: "1.2.0"
allowed-tools: Task, TaskOutput, TodoWrite, Bash(gh:*), Bash(git:*), Edit, Glob, Grep, Read, WebFetch, Write
think: true
author: "roksechs"
source: "https://gist.github.com/roksechs/3f24797d4b4e7519e18b7835c6d8a2d3"
contributors:
  - "kieranklaassen (parallel sub-agent patterns): https://gist.github.com/kieranklaassen/0c91cfaaf99ab600e79ba898918cea8a"
---

## PR Review Responder

Respond to GitHub PR review feedback with systematic resolution and thread management.

**Lifecycle**: `/rok-shape-issues` → `/rok-resolve-issues` → `/rok-review-pr` → `/rok-respond-to-reviews`

## Workflow

### 1. Retrieve Unresolved Comments

Use GraphQL to get review threads with resolution status (preferred over REST):

```bash
gh api graphql -f query='...' -f owner="OWNER" -f repo="REPO" -F pr=NUMBER
```

**Key fields**: `reviewThreads.nodes[].id` (thread ID for resolution), `isResolved`, `path`, `line`, `comments.nodes[].body`

### 2. Analyze & Prioritize

- **Priority**: Critical → Major → Minor → Enhancement
- **Independence**: Comments in different files can be fixed in parallel
- **Dependencies**: Same-file or logically related comments fix sequentially
- Track with `TodoWrite`

### 3. Implement Fixes

**Parallel resolution** (use Task tool with sub-agents):

- Spawn parallel agents for independent comments in different files
- Each agent: read context, make fix, report changes

**Sequential resolution**:

- Address dependent comments in priority order
- Commit after each logical group of fixes

### 4. Respond & Resolve

For each addressed comment:

1. **Reply** with fix details (commit hash, what changed, reasoning)
2. **Resolve thread** via GraphQL mutation

### 5. Finalize

- Commit and push all changes
- Post summary comment on PR if significant changes made

## GitHub API Reference

### Key Endpoints

| Action | Method | Notes |
| ------ | ------ | ----- |
| Get review threads | `gh api graphql` | Use `reviewThreads` query; returns thread `id` for resolution |
| Get PR comments | `gh api repos/.../pulls/NUMBER/comments` | Returns numeric `id` for replies |
| Reply to comment | `gh api repos/.../pulls/NUMBER/comments -f body="..." -F in_reply_to=ID` | Use **numeric** ID from REST, not GraphQL node ID |
| Resolve thread | `gh api graphql` mutation | Use **GraphQL node ID** (e.g., `PRRT_...`) |

### Critical Gotchas

1. **Two ID systems**: GraphQL returns node IDs (`PRRT_...`, `PRRC_...`), REST returns numeric IDs. Match ID type to endpoint.
2. **Reply requires numeric ID**: Get with `gh api repos/.../pulls/NUMBER/comments | jq '.[] | .id'`
3. **Resolve requires node ID**: Get from GraphQL `reviewThreads.nodes[].id`
4. **Comment reactions**: Use `repos/.../pulls/comments/NUMERIC_ID/reactions` endpoint

### GraphQL Snippets

**Get threads** - Query `repository.pullRequest.reviewThreads` with fields: `id`, `isResolved`, `path`, `line`, `comments.nodes[].body`

**Resolve thread** - Mutation `resolveReviewThread(input: {threadId: $threadId})` where `threadId` is the GraphQL node ID

## AI Reviewer Response Strategy

### Accept vs Reject

**Accept** when: genuine security risk, improves quality without complexity, aligns with project standards

**Reject** when: theoretical worst-case scenarios, permission already requires approval ("ask" list), command needed for dev workflow

### Response Templates

**Accepted**:

```markdown
**Fixed in commit: [hash]**
Changed: [description]
Reason: [why reviewer was correct]
```

**Rejected**:

```markdown
**Acknowledged but not implementing.**
Reason: [why this doesn't apply]
- [technical justification]
```

### Provide AI Feedback

Reply to each AI comment explaining agreement/disagreement - this creates a learning record for future reviews.
