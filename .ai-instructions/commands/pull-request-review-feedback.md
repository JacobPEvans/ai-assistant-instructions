# Pull Request Review Feedback Management with GraphQL

<!-- markdownlint-disable-file MD013 MD033 -->

This document contains the **EXACT, TESTED, WORKING** GraphQL queries and commands for managing pull request review feedback and conversations. These queries have been successfully tested and verified to work.

## 🚨 CRITICAL RULES

### **NEVER SUPPRESS LINTERS OR QUALITY CHECKS**

**ABSOLUTE RULE:** You are **NEVER** allowed to suppress, ignore, or disable linting errors, type checking errors, or any code quality issues by:
- Adding `# noqa` comments
- Adding `# pylint: disable` comments
- Adding `# type: ignore` comments
- Modifying `.flake8`, `pyproject.toml`, or any config files to ignore specific errors
- Using `per-file-ignores` or similar mechanisms

**ALWAYS FIX THE ROOT CAUSE.** If there's a linting error, fix the actual code issue. This rule exists because suppressing errors masks real problems and reduces code quality.

### **ALWAYS RESOLVE CONVERSATIONS AFTER FIXING ISSUES**

Only mark conversations as resolved **AFTER** you have actually fixed the underlying issues. Never resolve conversations just to make the PR appear clean.

## Overview: Two-Step Process

Managing PR review feedback involves exactly **TWO** key steps:

1. **📋 STEP 1: Get ALL review conversations and comments** - Find everything that needs to be addressed
2. **✅ STEP 2: Resolve conversations after fixing issues** - Mark conversations as resolved using GraphQL

## Variables Explained

Throughout this document, you'll see these variables. Here's what they mean and how to get them:

- **`$OWNER`**: The GitHub username or organization name that owns the repository
  - Example: `"JacobPEvans"`
  - Found in: GitHub URL `https://github.com/OWNER/REPO`

- **`$REPO`**: The repository name
  - Example: `"ai-assistant-instructions"`
  - Found in: GitHub URL `https://github.com/OWNER/REPO`

- **`$PR_NUMBER`**: The pull request number (integer, no quotes)
  - Example: `2` (not `"2"`)
  - Found in: PR URL `https://github.com/OWNER/REPO/pull/PR_NUMBER`

- **`$THREAD_ID`**: The unique GraphQL node ID for a review thread
  - Example: `"PRRT_kwDOPLZ56M5UgSNm"`
  - Found in: Response from Step 1 queries (starts with `PRRT_`)

## 📋 STEP 1: Get ALL Review Conversations and Comments

### Method 1A: Get Review Threads with GraphQL (RECOMMENDED)

This is the **primary method** - it gets all review threads and their resolution status.

**EXACT WORKING QUERY:**

```bash
gh api graphql --field query='
{
  repository(owner: "$OWNER", name: "$REPO") {
    pullRequest(number: $PR_NUMBER) {
      reviewThreads(first: 50) {
        nodes {
          id
          isResolved
          comments(first: 10) {
            nodes {
              id
              body
              path
              line
              user {
                login
              }
            }
          }
        }
      }
    }
  }
}'
```

**With Variable Substitution (replace these values):**

```bash
# REPLACE THESE VALUES:
OWNER="JacobPEvans"              # Repository owner
REPO="python-template"           # Repository name
PR_NUMBER=2                      # Pull request number (integer)

# ACTUAL WORKING COMMAND:
gh api graphql --field query="
{
  repository(owner: \"$OWNER\", name: \"$REPO\") {
    pullRequest(number: $PR_NUMBER) {
      reviewThreads(first: 50) {
        nodes {
          id
          isResolved
          comments(first: 10) {
            nodes {
              id
              body
              path
              line
              user {
                login
              }
            }
          }
        }
      }
    }
  }
}"
```

**Example Response Structure:**
```json
{
  "data": {
    "repository": {
      "pullRequest": {
        "reviewThreads": {
          "nodes": [
            {
              "id": "PRRT_kwDOPLZ56M5UgSNm",
              "isResolved": false,
              "comments": {
                "nodes": [
                  {
                    "id": "PRRC_kwDOPLZ56M6DV0hO",
                    "body": "Consider consolidating this information...",
                    "path": "README.md",
                    "line": 83,
                    "user": {
                      "login": "gemini-code-assist[bot]"
                    }
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

### Method 1B: Get Review Comments with REST API (Alternative)

This method gets the same data using REST API instead of GraphQL.

**EXACT WORKING COMMAND:**

```bash
gh api repos/$OWNER/$REPO/pulls/$PR_NUMBER/comments
```

**With Variable Substitution:**

```bash
# REPLACE THESE VALUES:
OWNER="JacobPEvans"              # Repository owner
REPO="python-template"           # Repository name
PR_NUMBER=2                      # Pull request number

# ACTUAL WORKING COMMAND:
gh api repos/$OWNER/$REPO/pulls/$PR_NUMBER/comments
```

### Method 1C: Comprehensive Review Data (Complete Picture)

Get ALL review-related data including reviews, comments, and status.

**EXACT WORKING QUERY:**

```bash
gh api graphql --field query='
{
  repository(owner: "$OWNER", name: "$REPO") {
    pullRequest(number: $PR_NUMBER) {
      title
      state
      mergeable
      reviews(first: 20) {
        nodes {
          id
          state
          body
          user {
            login
          }
        }
      }
      reviewThreads(first: 50) {
        nodes {
          id
          isResolved
          comments(first: 10) {
            nodes {
              id
              body
              path
              line
              user {
                login
              }
            }
          }
        }
      }
      comments(first: 20) {
        nodes {
          id
          body
          user {
            login
          }
        }
      }
    }
  }
}'
```

## ✅ STEP 2: Resolve Conversations After Fixing Issues

### Single Conversation Resolution

After you've **actually fixed the issues** mentioned in a conversation, resolve it with this **EXACT WORKING MUTATION:**

```bash
gh api graphql --field query='
mutation {
  resolveReviewThread(input: {threadId: "$THREAD_ID"}) {
    thread {
      id
      isResolved
    }
  }
}'
```

**With Variable Substitution:**

```bash
# REPLACE THIS VALUE:
THREAD_ID="PRRT_kwDOPLZ56M5UgSNm"    # From Step 1 response

# ACTUAL WORKING COMMAND:
gh api graphql --field query="
mutation {
  resolveReviewThread(input: {threadId: \"$THREAD_ID\"}) {
    thread {
      id
      isResolved
    }
  }
}"
```

**Success Response:**
```json
{
  "data": {
    "resolveReviewThread": {
      "thread": {
        "id": "PRRT_kwDOPLZ56M5UgSNm",
        "isResolved": true
      }
    }
  }
}
```

### Batch Resolution of Multiple Conversations

If you have many conversations to resolve, use this approach:

**Step 2A: Get All Unresolved Thread IDs**

```bash
# Get only unresolved thread IDs
gh api graphql --field query='
{
  repository(owner: "$OWNER", name: "$REPO") {
    pullRequest(number: $PR_NUMBER) {
      reviewThreads(first: 50) {
        nodes {
          id
          isResolved
        }
      }
    }
  }
}' | jq -r '.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false) | .id'
```

**Step 2B: Resolve Each Thread**

```bash
# Loop through and resolve each unresolved thread
UNRESOLVED_IDS=$(gh api graphql --field query='
{
  repository(owner: "$OWNER", name: "$REPO") {
    pullRequest(number: $PR_NUMBER) {
      reviewThreads(first: 50) {
        nodes {
          id
          isResolved
        }
      }
    }
  }
}' | jq -r '.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false) | .id')

for thread_id in $UNRESOLVED_IDS; do
    echo "Resolving thread: $thread_id"
    gh api graphql --field query="
    mutation {
      resolveReviewThread(input: {threadId: \"$thread_id\"}) {
        thread {
          id
          isResolved
        }
      }
    }"
done
```

## 🔍 Verification: Check Resolution Status

After resolving conversations, verify they're actually resolved:

```bash
gh api graphql --field query='
{
  repository(owner: "$OWNER", name: "$REPO") {
    pullRequest(number: $PR_NUMBER) {
      reviewThreads(first: 50) {
        nodes {
          id
          isResolved
        }
      }
    }
  }
}'
```

## 📝 Complete Workflow Example

Here's a real example from successfully resolving all conversations on python-template PR #2:

### Step 1: Get Conversations
```bash
gh api graphql --field query='
{
  repository(owner: "JacobPEvans", name: "python-template") {
    pullRequest(number: 2) {
      reviewThreads(first: 10) {
        nodes {
          id
          isResolved
          comments(first: 10) {
            nodes {
              id
              body
            }
          }
        }
      }
    }
  }
}'
```

Response showed 6 threads, 3 already resolved, 3 unresolved:
- `PRRT_kwDOPLZ56M5UgSNo` (unresolved)
- `PRRT_kwDOPLZ56M5UgSNp` (unresolved)
- `PRRT_kwDOPLZ56M5UgSNq` (unresolved)

### Step 2: Fix Issues Then Resolve
After fixing the actual code issues (README formatting, gitignore patterns, etc.):

```bash
# Resolve thread 1
gh api graphql --field query='
mutation {
  resolveReviewThread(input: {threadId: "PRRT_kwDOPLZ56M5UgSNo"}) {
    thread { id isResolved }
  }
}'

# Resolve thread 2
gh api graphql --field query='
mutation {
  resolveReviewThread(input: {threadId: "PRRT_kwDOPLZ56M5UgSNp"}) {
    thread { id isResolved }
  }
}'

# Resolve thread 3
gh api graphql --field query='
mutation {
  resolveReviewThread(input: {threadId: "PRRT_kwDOPLZ56M5UgSNq"}) {
    thread { id isResolved }
  }
}'
```

### Step 3: Verify All Resolved
```bash
gh api graphql --field query='
{
  repository(owner: "JacobPEvans", name: "python-template") {
    pullRequest(number: 2) {
      reviewThreads(first: 10) {
        nodes {
          id
          isResolved
        }
      }
    }
  }
}'
```

Result: All 6 threads showing `"isResolved": true` ✅

## 🛠️ Troubleshooting

### Common Issues and Solutions

**Q: GraphQL query returns empty reviewThreads**
- Check that PR_NUMBER is correct and exists
- Verify OWNER and REPO are spelled correctly
- Try the REST API method as alternative

**Q: resolveReviewThread mutation fails**
- Ensure THREAD_ID is exactly as returned from Step 1 (starts with `PRRT_`)
- Check that you have write permissions to the repository
- Verify the thread actually exists and isn't already resolved

**Q: Variables not substituting correctly**
- Use double quotes around the entire query when substituting variables
- Escape inner quotes with backslashes: `\"$VARIABLE\"`
- For integers like PR_NUMBER, don't use quotes in the GraphQL

### Thread ID Format

Valid thread IDs always follow this pattern:
- **Format:** `PRRT_` followed by alphanumeric characters
- **Example:** `PRRT_kwDOPLZ56M5UgSNm`
- **Invalid:** Any ID not starting with `PRRT_`

### Required Permissions

To resolve conversations, you need:
- Write access to the repository
- GitHub CLI authenticated (`gh auth status`)
- Pull request must be open (not merged/closed)

## 🎯 Success Criteria

You know you've succeeded when:

1. **Step 1 Response**: Shows all review threads with their resolution status
2. **Step 2 Response**: Each resolve mutation returns `"isResolved": true`
3. **Final Verification**: All threads show `"isResolved": true`
4. **GitHub UI**: PR shows "All conversations resolved" ✅

These GraphQL queries have been tested and verified to work successfully. Follow them exactly as documented for reliable results.
