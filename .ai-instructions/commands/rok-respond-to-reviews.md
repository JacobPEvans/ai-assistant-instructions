---
title: "Respond to Reviews"
description: "Respond to PR review feedback efficiently with systematic resolution, parallel sub-agents, and GitHub thread resolution"
type: "command"
version: "1.1.0"
tools: ["*"]
think: true
author: "roksechs"
source: "https://gist.github.com/roksechs/3f24797d4b4e7519e18b7835c6d8a2d3"
contributors:
  - "kieranklaassen (parallel sub-agent patterns): https://gist.github.com/kieranklaassen/0c91cfaaf99ab600e79ba898918cea8a"
---

## PR Review Responder

> **Attribution**: This command is from [roksechs](https://gist.github.com/roksechs/3f24797d4b4e7519e18b7835c6d8a2d3)
> **Enhanced with**: Parallel sub-agent patterns from
> [kieranklaassen](https://gist.github.com/kieranklaassen/0c91cfaaf99ab600e79ba898918cea8a)
> Part of the development lifecycle:
> `/rok-shape-issues` -> `/rok-resolve-issues` -> `/rok-review-pr` -> `/rok-respond-to-reviews`

Efficient and comprehensive system for responding to GitHub Pull Request review feedback
with systematic resolution, parallel sub-agent coordination, and strategic follow-up.

### Core Capabilities

**Phase 1: Efficient Comment Retrieval** (information_gathering)

- **Optimized API calls**: Use `gh api` + `jq` for efficient comment extraction
- **Unresolved focus**: Target only `resolved: false` comments
- **Structured data**: Extract comment ID, line number, file path, content
- **Token optimization**: Minimize API consumption through selective filtering

**Phase 2: Comment Analysis & Response Planning** (analysis_planning)

- **Priority assessment**: Critical -> Major -> Minor -> Enhancement
- **Relationship analysis**: Identify connections between multiple comments
- **Independence detection**: Identify comments that can be fixed in parallel
- **Implementation strategy**: Determine efficient resolution order
- **Impact evaluation**: Predict side effects of proposed changes

**Phase 3: Parallel Sub-Agent Resolution** (parallel_resolution)

- **Independent comment detection**: Identify comments in different files or with no dependencies
- **Sub-agent coordination**: Spawn parallel agents to fix independent comments simultaneously
- **Progress tracking**: Use TodoWrite for real-time visualization
- **Conflict prevention**: Ensure parallel changes don't interfere with each other

**Phase 4: Systematic Implementation & Response** (implementation_response)

- **Progressive resolution**: Address comments by priority with progress tracking
- **Quality assurance**: Comprehensive TypeScript, testing, lint, build checks
- **Appropriate responses**: Detailed explanations for each comment
- **Change documentation**: Record modification details and rationale
- **Thread resolution**: Mark GitHub review threads as resolved via GraphQL

### Efficient GitHub CLI Usage

> **Command Patterns:**

#### Basic Comment Retrieval

```bash
# Retrieve all PR comments (basic approach)
gh api repos/:owner/:repo/pulls/{PR_NUMBER}/comments

# Get unresolved comments only (optimized)
gh api repos/:owner/:repo/pulls/{PR_NUMBER}/comments | \
  jq '.[] | select(.resolved == false)'

# Extract essential information only (token-efficient)
gh api repos/:owner/:repo/pulls/{PR_NUMBER}/comments | \
  jq '.[] | select(.resolved == false) | {id, line, path, body, in_reply_to_id}'
```

#### GraphQL for Review Threads (Recommended)

```bash
# Get all review threads with resolution status
gh api graphql -f query='
  query($owner: String!, $repo: String!, $pr: Int!) {
    repository(owner: $owner, name: $repo) {
      pullRequest(number: $pr) {
        reviewThreads(first: 100) {
          nodes {
            id
            isResolved
            path
            line
            comments(first: 50) {
              nodes {
                body
                author { login }
              }
            }
          }
        }
      }
    }
  }
'

# Resolve a review thread
gh api graphql -f query='
  mutation($threadId: ID!) {
    resolveReviewThread(input: {threadId: $threadId}) {
      thread { isResolved }
    }
  }
' -f threadId="{THREAD_ID}"
```

#### Targeted File Comments

```bash
# Comments for specific files only
gh api repos/:owner/:repo/pulls/{PR_NUMBER}/comments | \
  jq '.[] | select(.path | test("target_pattern") and .resolved == false)'
```

#### Comment Response & Change Recording

```bash
# Reply to comments
gh api repos/:owner/:repo/pulls/{PR_NUMBER}/comments \
  -f body="response_content" -F in_reply_to={COMMENT_ID}

# MANDATORY: Commit and push changes
git add .
git commit -m "fix: address review feedback - [brief description]"
git push

# Link commit in response comments
gh api repos/:owner/:repo/pulls/{PR_NUMBER}/comments \
  -f body="Fixed in commit: [commit_hash]"
```

### Parallel Sub-Agent Resolution

> **Parallel Processing:**

#### When to Use Parallel Sub-Agents

Analyze the unresolved comments and use parallel processing when:

- Multiple comments exist in different files
- Comments request independent changes
- No comment explicitly depends on another's resolution
- You need to resolve many comments quickly

#### Parallel Comment Resolution Pattern

```text
Step 1: Retrieve and analyze all unresolved comments
Step 2: Categorize comments by independence:
        - Independent: Can be fixed in parallel (different files, no dependencies)
        - Dependent: Must be fixed sequentially (same file region, logical dependencies)
Step 3: Spawn sub-agents for independent comments:
        - Sub-Agent 1: "Add null check" in src/api/user.js:45
        - Sub-Agent 2: "Missing error handling" in src/api/auth.js:102
        - Sub-Agent 3: "Typo: 'recieve' -> 'receive'" in README.md:23
        - Sub-Agent 4: "Extract magic number to constant" in src/utils/calc.js:67
Step 4: Coordinate and merge parallel fixes
Step 5: Handle dependent comments sequentially
Step 6: Run quality checks on combined changes
```

#### Sub-Agent Task Format

When spawning sub-agents, provide clear context:

```text
Task: Fix review comment in {file_path}:{line_number}
Comment: "{comment_body}"
Context: {surrounding_code_context}
Requirements:
1. Make the specific fix requested
2. Ensure change doesn't break related code
3. Add tests if behavior changes
4. Report back: file changed, lines modified, brief description
```

### Strategic Workflow

> **Workflow Steps:**

#### Step 1: Information Collection

```bash
# Efficient comment retrieval pattern
gh api repos/:owner/:repo/pulls/{PR_NUMBER}/comments | jq '
  .[] |
  select(.resolved == false) |
  {
    id,
    line,
    path,
    body: (.body | .[0:100] + "..."),
    in_reply_to_id,
    created_at
  }
'
```

#### Step 2: Analysis & Planning

- Analyze each comment's content and context
- Determine resolution priority and sequence
- **Identify independent vs dependent comments**
- Group related comments for efficient handling
- Record implementation plan using TodoWrite

#### Step 3: Parallel Resolution (for independent comments)

- Spawn sub-agents for comments in different files
- Each sub-agent focuses on a single comment
- Monitor progress and collect results
- Merge changes when all sub-agents complete

#### Step 4: Sequential Resolution (for dependent comments)

- Address remaining comments by priority
- Provide appropriate responses after each fix
- Handle comments that depend on previous fixes

#### Step 5: Quality Assurance & Finalization

- Execute comprehensive quality checks
- **MANDATORY**: Commit changes with descriptive messages
- **MANDATORY**: Push to remote branch for GitHub visibility
- Document final change summary and link commit references
- **Mark all review threads as resolved** using GraphQL mutation

### Best Practices

> **Best Practices:**

#### Efficiency

- **Parallel processing**: Use sub-agents for independent comments
- **Batch processing**: Handle related comments together
- **Priority order**: Critical -> Major -> Minor sequence
- **API optimization**: Use jq filters for selective data extraction

#### Quality

- **Comprehensive testing**: Verify all quality gates
- **Incremental implementation**: Build changes systematically
- **Detailed documentation**: Record rationale and impact scope

#### Communication

- **Professional responses**: Provide clear explanations for each resolution
- **Transparency**: Clearly communicate changes and reasoning
- **Commit linking**: Always reference specific commits in response comments
- **GitHub visibility**: Ensure all changes are pushed and visible on GitHub
- **Thread resolution**: Mark threads as resolved after addressing them
- **Continuous improvement**: Learn from feedback patterns

### Response Strategy for Recurring AI Comments

When responding to automated AI reviewer comments (e.g., Copilot, CodeRabbit), apply these principles:

#### Always Explain Your Reasoning

For EVERY comment, provide a detailed explanation of why you:

- **Agreed**: Explain what was wrong and how you fixed it
- **Disagreed**: Explain why the comment is not applicable, overly cautious, or incorrect

This creates a learning record for AI reviewers and helps future reviews be more accurate.

#### Add Code Comments to Prevent Recurring Comments

When a legitimate pattern keeps triggering false-positive reviews, add inline comments:

```python
# NOTE: This permission is intentional - darwin-rebuild is required for Nix development
"Bash(darwin-rebuild switch:*)"

# NOTE: git push is safe here - branch protection prevents force-push to main
"Bash(git push:*)"
```

#### Recognize Overbearing Patterns

Some AI comments are overly cautious and should be addressed firmly:

| Comment Pattern | Response Approach |
|-----------------|-------------------|
| "Consider adding to deny list" | Reject if already in "ask" list - ask = user approval required |
| "Read all files is risky" | Reject - we use secure key management, not plaintext files |
| "Eval/exec is dangerous" | Reject - still requires user approval, AI cannot run silently |
| "Inconsistent command formats" | Reject - different sources, common prefix indicates origin |
| "Add more deny permissions" | Reject - anything not in allow/ask already requires approval |
| "git push could be destructive" | Reject - branch protection prevents force-push to main |
| "darwin-rebuild could break system" | Reject - required for Nix development workflow |

#### When to Accept vs. Reject

**ACCEPT when**:

- The comment identifies a genuine security risk (e.g., `rm -rf /` without safeguards)
- The fix improves code quality without adding unnecessary complexity
- The suggestion aligns with project standards

**REJECT when**:

- The comment is based on worst-case theoretical scenarios, not likely failures
- The permission already requires user approval ("ask" list)
- The command is required for the project's development workflow
- The reviewer is applying generic security advice that doesn't fit this context

#### Response Template for Rejected Comments

```markdown
**Acknowledged but not implementing.**

Reason: [Explain why this doesn't apply]
- [Specific technical justification]
- [Reference to existing safeguards if applicable]

This pattern is documented in our review guidelines. Resolving thread.
```

#### Response Template for Accepted Comments

```markdown
**Fixed in commit: [commit_hash]**

Changed: [What was changed]
Reason: [Why the reviewer was correct]
Prevention: [Code comment added to prevent future occurrences, if applicable]
```

### Usage Instructions

> **Usage:**
>
> **Command Execution**: `/rok-respond-to-reviews`
>
> **Example Prompts**:
>
> - "Handle all unresolved review comments on the current PR"
> - "Address file-level and line-level comments with appropriate fixes and responses"
> - "Systematically resolve review feedback and provide comprehensive responses"
> - "Use parallel sub-agents to quickly resolve independent review comments"
> - "Fix all review comments and mark the threads as resolved"

**Workflow Integration**:

- **Upstream context**: `/rok-shape-issues` -> `/rok-resolve-issues` -> `/rok-review-pr`
  provides full development context
- **Final step**: Complete the development lifecycle with systematic review response and resolution

**Complete Development Lifecycle**:
`/rok-shape-issues` -> `/rok-resolve-issues` -> `/rok-review-pr` -> `/rok-respond-to-reviews`

This command significantly streamlines the PR review process with parallel sub-agent coordination,
enabling high-quality, efficient response management and automatic thread resolution.
