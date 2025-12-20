---
title: "Resolve PR Review Thread"
description: "Resolve PR review threads efficiently with systematic analysis, implementation/response, and mandatory GraphQL thread resolution"
model: sonnet
type: "command"
version: "2.0.0"
allowed-tools: Task, TaskOutput, TodoWrite, Bash(gh:*), Bash(git:*), Edit, Glob, Grep, Read, WebFetch, Write
think: true
author: "roksechs"
source: "https://gist.github.com/roksechs/3f24797d4b4e7519e18b7835c6d8a2d3"
contributors:
  - "kieranklaassen (parallel sub-agent patterns): https://gist.github.com/kieranklaassen/0c91cfaaf99ab600e79ba898918cea8a"
---

## PR Review Thread Resolver

Resolve GitHub PR review threads with systematic analysis, implementation or explanation, and mandatory GraphQL thread resolution.

## CRITICAL REQUIREMENT: ALL Comments Must Be Resolved

**EVERY SINGLE PR comment must be marked as resolved** via `gh api graphql` mutation `resolvePullRequestReviewThread`.

There are exactly **TWO paths** to resolve a comment:

1. **Technical Resolution (with commit)**:
   - Implement the requested change
   - Commit the fix
   - Reply with commit hash and explanation
   - **Mark thread as resolved via GraphQL**

2. **Response-Only Resolution (without commit)**:
   - Provide explanation for why change is not being implemented
   - Reply with clear reasoning
   - **Mark thread as resolved via GraphQL**

**BOTH paths require marking the thread as resolved.** No comment should remain unresolved after this command completes.

## Scope

**CURRENT PR ONLY** - This command operates on the PR associated with the current branch or worktree.

> **PR Comment Limit**: This command respects the **50-comment limit per PR** defined in the
> [PR Comment Limits rule](../rules/pr-comment-limits.md).
> When resolving threads, do not post new comments if a PR has reached 50 comments.

## Related Documentation

- [Subagent Parallelization](../rules/subagent-parallelization.md) - Parallel execution patterns for independent comments
- [PR Comment Limits](../rules/pr-comment-limits.md) - 50-comment limit enforcement

## Quick Reference

Essential commands for PR review thread management.

**Note**: Replace OWNER, REPO, PR_NUMBER, and thread IDs with actual values from your repository.

```bash
# 1. Get all review threads
gh api graphql -f query='{
  repository(owner: "OWNER", name: "REPO") {
    pullRequest(number: 123) {
      reviewThreads(first: 50) {
        nodes {
          id
          isResolved
          comments(first: 5) {
            nodes {
              body
              path
              line
            }
          }
        }
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

### 4. Address & Resolve

For each addressed comment:

1. **Reply** with fix details (commit hash, what changed, reasoning)
2. **Resolve thread** via GraphQL mutation

### 5. Finalize

- Commit and push all changes
- Post summary comment on PR if significant changes made

## How to Interpret PR Comments

This section provides explicit, ordered steps for locating, interpreting, and acting on PR review comments reliably.

### Step-by-Step Comment Interpretation Process

Follow these steps in order for each PR comment:

#### 1. Locate and Extract Comment Data

**Action**: Use GraphQL to retrieve all review threads with complete context.

<!-- markdownlint-disable MD013 -->
<!-- Long line required: Claude Code has encoding issues with multi-line GraphQL -->

```bash
# IMPORTANT: Use --raw-field and single-line query to avoid encoding issues in Claude Code
gh api graphql --raw-field 'query=query { repository(owner: "OWNER", name: "REPO") { pullRequest(number: NUMBER) { reviewThreads(first: 50) { nodes { id isResolved path line startLine comments(first: 10) { nodes { id databaseId body author { login } createdAt } } } } } } }'
```

> **Technical Requirement**: Multi-line GraphQL queries cause encoding issues in Claude Code.
> Use `--raw-field` with single-line format (exceeds 160 chars by necessity).

<!-- markdownlint-enable MD013 -->

**Extract these fields**:

- `id`: Thread ID for resolution (starts with `PRRT_`)
- `isResolved`: Skip if true, process if false
- `path`: File being commented on
- `line`/`startLine`: Location in file
- `comments.nodes[].body`: The actual comment text
- `comments.nodes[].author.login`: Who wrote it

#### 2. Identify Comment Type

Read the comment body and classify it:

**A. Suggestion with code** (contains ` ```suggestion ` block):

- GitHub's suggestion syntax for direct code changes
- Can be applied directly via UI or manually
- **Action required**: Apply the suggested code change

**B. Question** (ends with `?` or phrases like "Could you explain..."):

- Reviewer seeking clarification or rationale
- **Action required**: Provide explanation in reply, may or may not need code changes

**C. Criticism/Issue** (points out a problem without suggesting fix):

- Identifies bug, security issue, or code smell
- Examples: "This has a race condition", "This breaks when X is null"
- **Action required**: Fix the issue, then explain fix in reply

**D. Suggestion without code** (uses "should", "consider", "recommend"):

- Reviewer proposes improvement but no code provided
- Examples: "Consider using a map here", "This should be extracted to a helper"
- **Action required**: Evaluate merit, implement if appropriate, explain decision

**E. Nitpick/Style** (prefixed with "nit:", "minor:", or describing trivial formatting):

- Minor style or formatting suggestion
- **Action required**: Quick fix if easy, explain if skipping

**F. Blocking** (contains "blocking", "must fix", "required before merge"):

- Critical issue that prevents merge
- **Action required**: Fix immediately, highest priority

#### 3. Read the Code Context

**Action**: Use Read tool to view the file and surrounding code.

```bash
# If comment is on line 45, read lines 30-60 for context
```

**Understand**:

- What is the code trying to do?
- What is the reviewer's concern in context?
- Are there related code patterns elsewhere in the file?

#### 4. Determine Appropriate Action

Use this decision tree:

```text
Is it a SUGGESTION with code?
├─ YES → Apply the code change exactly as suggested
└─ NO  → Continue

Is it a BLOCKING issue?
├─ YES → Fix immediately, highest priority
└─ NO  → Continue

Is it a QUESTION?
├─ YES → Can you answer without code changes?
│   ├─ YES → Reply with explanation, resolve thread
│   └─ NO  → Make code more clear, then explain in reply
└─ NO  → Continue

Does the criticism/suggestion have merit?
├─ YES → Implement fix, explain what you did
├─ NO  → Reply with respectful disagreement and rationale
└─ UNSURE → Ask clarifying question (rare - try to decide)
```

#### 5. Implement the Fix

**For code changes**:

1. Check out the branch: `git checkout <branch>`
2. Make the change using Edit tool
3. Verify change works (run tests if applicable)
4. Commit with descriptive message mentioning the review

**For non-code responses**:

- Prepare clear explanation referencing code, docs, or reasoning

#### 6. Reply AND Resolve (ALWAYS TOGETHER)

> **CRITICAL**: Never reply without resolving. Never resolve without replying. These are ONE atomic action.

**Action**: Post reply via PR comment, then immediately resolve thread via GraphQL.

**Step A - Post a general PR comment** (simplest and most reliable):

```bash
gh pr comment PR_NUMBER --body "**Response to review feedback:**

[Your detailed response here]"
```

**Step B - Resolve the thread** (MANDATORY - do this immediately after replying):

```bash
# Single-line format for reliability
gh api graphql --raw-field 'query=mutation { resolveReviewThread(input: {threadId: "PRRT_xxx"}) { thread { id isResolved } } }'
```

**Reply templates** (include in your PR comment):

**If fixed**:

```markdown
Fixed in commit [hash].

Changes made:
- [specific change 1]
- [specific change 2]
```

**If question answered**:

```markdown
[Answer with technical details]

The reason we do it this way is [rationale].
```

**If respectfully disagreeing**:

```markdown
Acknowledged but not implementing because:
1. [Technical reason 1]
2. [Technical reason 2]
```

<!-- markdownlint-disable MD013 -->

> **VERIFICATION**: After resolving, confirm with:
>
> ```bash
> gh api graphql --raw-field 'query=query { repository(owner: "OWNER", name: "REPO") { pullRequest(number: NUMBER) { reviewThreads(first: 50) { nodes { isResolved } } } } }' | jq '[.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false)] | length'
> ```
>
> Must return `0` before moving on.

<!-- markdownlint-enable MD013 -->

#### 7. Commit and Push

```bash
git add <files>
git commit -m "fix: address PR review comment on <topic>

- [specific changes made]

Addresses review comment: <PR_URL>#discussion_r<comment_id>"

git push
```

## Real-World Examples

### Example 1: Suggestion with Code Block

**Comment Body**:

<!-- markdownlint-disable MD040 -->

```markdown
This function could be simplified using destructuring:

```suggestion
const { name, email, role } = user;
console.log(`User: ${name} (${email})`);
```

```

<!-- markdownlint-enable MD040 -->

**Context**:
- File: `src/utils/user-formatter.ts`
- Line: 45
- Current code:
  ```typescript
  const name = user.name;
  const email = user.email;
  const role = user.role;
  console.log(`User: ${name} (${email})`);
  ```

**Expected Claude Action**:

1. **Identify type**: Suggestion with code (contains ` ```suggestion ` block)
2. **Read context**: View lines 40-50 in `src/utils/user-formatter.ts`
3. **Determine action**: Apply suggested code exactly
4. **Implement fix**:

   ```bash
   # Edit the file to use destructuring
   ```

5. **Reply to comment**:

   ```markdown
   Applied in commit abc123f.

   Changed to use destructuring as suggested. This is cleaner and more idiomatic.
   ```

6. **Resolve thread** using GraphQL mutation
7. **Commit**: `git commit -m "refactor: use destructuring in user formatter"`

### Example 2: Critical Bug Report (Blocking)

**Comment Body**:

```markdown
BLOCKING: This has a race condition. If two requests come in simultaneously,
they could both pass the `if (!cache[key])` check and make duplicate API calls.

You need to use a mutex or promise deduplication here.
```

**Context**:

- File: `src/api/cache-manager.ts`
- Line: 78
- Current code:

  ```typescript
  async function fetchWithCache(key: string) {
    if (!cache[key]) {
      cache[key] = await expensiveAPICall(key);
    }
    return cache[key];
  }
  ```

**Expected Claude Action**:

1. **Identify type**: Blocking criticism (contains "BLOCKING", describes bug)
2. **Read context**: View entire cache-manager.ts to understand caching strategy
3. **Determine action**: Fix immediately (highest priority)
4. **Implement fix**:

   ```typescript
   const pendingRequests = new Map<string, Promise<any>>();

   async function fetchWithCache(key: string) {
     if (cache[key]) {
       return cache[key];
     }

     if (pendingRequests.has(key)) {
       return pendingRequests.get(key);
     }

     const promise = expensiveAPICall(key).then(result => {
       cache[key] = result;
       pendingRequests.delete(key);
       return result;
     });

     pendingRequests.set(key, promise);
     return promise;
   }
   ```

5. **Reply to comment**:

   ```markdown
   Fixed in commit def456a.

   You're absolutely right - there was a race condition. Implemented promise
   deduplication using a `pendingRequests` Map to ensure only one API call
   happens per key, even with concurrent requests.

   Changes:
   - Track in-flight requests in a Map
   - Return existing promise if request is already pending
   - Clean up Map entry after request completes
   ```

6. **Resolve thread**
7. **Commit**: `git commit -m "fix: resolve race condition in cache manager"`

### Example 3: Question Requiring Clarification

**Comment Body**:

```markdown
Why are we using a custom debounce implementation here instead of lodash.debounce?

Is there a specific reason we can't use the standard library function?
```

**Context**:

- File: `src/hooks/useSearch.ts`
- Line: 23
- Current code uses custom 15-line debounce function

**Expected Claude Action**:

1. **Identify type**: Question (ends with `?`, seeks rationale)
2. **Read context**: Review custom debounce implementation and package.json
3. **Determine action**: Check if lodash is available, decide if change needed
4. **Evaluate**:
   - Is lodash in dependencies? Check `package.json`
   - Is there a technical reason for custom implementation?
   - Would lodash.debounce be better?
5. **Decision** (two possible paths):

   **Path A: Lodash is available and custom implementation isn't needed**
   - Replace custom debounce with `lodash.debounce`
   - Reply:

     ```markdown
     Good catch! Switched to lodash.debounce in commit ghi789b.

     There wasn't a specific reason for the custom implementation - lodash.debounce
     is more battle-tested and handles edge cases better. Removed 15 lines of
     custom code.
     ```

   **Path B: Custom implementation is needed**
   - Keep custom implementation
   - Reply:

     ```markdown
     Good question! We need the custom implementation because:

     1. Our version supports immediate cancellation via a cancel token, which
        lodash.debounce doesn't provide
     2. Adding lodash just for debounce would add 70KB to the bundle
     3. Our implementation is React-specific and handles unmounting properly

     Added a comment in the code explaining this rationale (commit ghi789b).
     ```

6. **Resolve thread**
7. **Commit** (if code changed): Appropriate message for the action taken

### Example 4: Style Nitpick

**Comment Body**:

```markdown
nit: This variable name could be more descriptive. `data` is quite generic.
```

**Context**:

- File: `src/components/Dashboard.tsx`
- Line: 67
- Current code: `const data = await fetchUserAnalytics();`

**Expected Claude Action**:

1. **Identify type**: Nitpick (prefixed with "nit:")
2. **Read context**: See how `data` is used in the component
3. **Determine action**: Quick fix (easy change, improves clarity)
4. **Implement fix**:

   ```typescript
   const userAnalytics = await fetchUserAnalytics();
   ```

   Update all references to `data` → `userAnalytics`
5. **Reply to comment**:

   ```markdown
   Fixed in commit jkl012c. Renamed to `userAnalytics` for clarity.
   ```

6. **Resolve thread**
7. **Commit**: `git commit -m "refactor: use more descriptive variable name in Dashboard"`

## Edge Cases and Special Situations

### Suggestion Blocks with Multiple Lines

**Situation**: GitHub suggestion syntax with multi-line changes.

**Example**:

<!-- markdownlint-disable MD040 -->

```markdown
```suggestion
export function calculateTotal(items: Item[]): number {
  return items.reduce((sum, item) => sum + item.price, 0);
}
```

```

<!-- markdownlint-enable MD040 -->

**Action**:
- Apply the ENTIRE code block exactly as shown
- GitHub's suggestion syntax is meant to be applied verbatim
- Do not "improve" or modify the suggestion - apply it as-is

### Multi-Threaded Conversations

**Situation**: Multiple people commenting on the same thread.

**Example**:
- Reviewer A: "This should use async/await"
- Reviewer B: "Actually, callbacks are fine here"
- Reviewer C: "Agree with Reviewer A"

**Action**:
1. Read ALL comments in the thread chronologically
2. Identify if consensus was reached (2+ reviewers agree)
3. If consensus: Follow the majority opinion
4. If no consensus: Make a decision based on:
   - Project conventions
   - Technical merit
   - Reviewer seniority (if known)
5. Reply explaining your decision and reasoning
6. Tag reviewers if asking for clarification: "@reviewer-name"

### Contradictory Feedback Across Different Threads

**Situation**: Two reviewers give conflicting feedback in separate threads.

**Example**:
- Thread 1: "Extract this into a separate function"
- Thread 2: "Inline this helper, it's only used once"

**Action**:
1. Reply to BOTH threads acknowledging the conflict
2. Propose a decision with rationale
3. Ask for consensus before implementing
4. Example reply:

   ```markdown
   @reviewer-a and @reviewer-b - I see conflicting feedback here.

   I propose [your decision] because [rationale].

   Let me know if you'd like me to take a different approach.
   ```

1. Wait for response before resolving (rare case where asking is appropriate)

### Comments on Deleted or Moved Lines

**Situation**: Comment references a line that no longer exists in current code.

**Action**:

1. Check git history: Was the line removed in a later commit?
2. If intentionally removed: Reply explaining why

   ```markdown
   This code was removed in commit xyz789d because [reason].

   The functionality is now handled by [new approach].
   ```

3. If moved: Reply with new location

   ```markdown
   This code was moved to [file]:[line] in commit xyz789d.
   ```

4. Resolve the outdated thread

### Outdated Comments After Force Push

**Situation**: Comments marked "outdated" after rebasing or amending commits.

**Action**:

1. View outdated comments: They still appear in GitHub, marked as outdated
2. If the concern is still relevant: Address it on the new code
3. If the concern is no longer relevant: Reply and resolve

   ```markdown
   This was addressed in the recent rebase - the code now [new approach].
   ```

4. Always resolve outdated threads after verifying they're addressed

### Batch Comments (Multiple Issues in One Comment)

**Situation**: Reviewer lists multiple issues in a single comment.

**Example**:

```markdown
A few things here:
1. Missing error handling
2. Variable name is unclear
3. This could be more efficient with a Set instead of Array
```

**Action**:

1. Address ALL items in the list
2. Reply with numbered responses matching the comment:

   ```markdown
   Addressed all three items in commit mno345p:

   1. Added try-catch with proper error logging
   2. Renamed `temp` to `processedUserIds`
   3. Switched from Array to Set for O(1) lookups
   ```

3. Do not resolve until ALL items are addressed
4. If you disagree with any item, address each separately in the reply

### Suggestion Syntax With Context Lines

**Situation**: GitHub shows context lines (unchanged) around the suggestion.

**Example**:

<!-- markdownlint-disable MD040 -->

```markdown
```suggestion
function processUser(user: User) {
  validateUser(user);  // ← Only this line changed
  return user;
}
```

```

<!-- markdownlint-enable MD040 -->

**Action**:
- Only modify the lines that actually changed in the suggestion
- GitHub shows 3 lines of context, but only the changed lines need updating
- Look for what's different from current code

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

### Troubleshooting

| Problem | Solution |
| ------- | -------- |
| Empty response | Check OWNER/REPO/PR_NUMBER are correct |
| Mutation fails | Verify thread ID starts with `PRRT_` |
| Permission denied | Run `gh auth status` to verify authentication |
| Variables not substituting | Use double quotes and escape inner quotes |

### Why This Matters

GitHub's branch protection can require "all conversations resolved" before merge. Without programmatic resolution,
autonomous PR management is impossible. This GraphQL approach enables:

- Automated CI/CD pipelines to resolve threads after fixing issues
- AI assistants to fully manage PRs without human intervention
- Batch resolution of multiple threads in one operation

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
