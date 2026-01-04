---
name: github-cli-patterns
description: Use when working with gh CLI. Provides patterns for PRs, issues, reviews, and repository operations.
version: "1.0.0"
author: "JacobPEvans"
---

# GitHub CLI Patterns

Common GitHub CLI (gh) command patterns used across commands and agents. Single source of truth for gh CLI usage to reduce duplication.

## Purpose

Provides standardized `gh` CLI patterns for:

- Pull request operations
- Issue management
- Review operations
- Repository queries
- Check and workflow status

All commands that use `gh` CLI should reference this skill for common patterns instead of duplicating examples.

## PR Operations

### List Pull Requests

```bash
# List all open PRs
gh pr list --state open

# List PRs with specific filters
gh pr list --state open --author @me
gh pr list --label "bug" --state open
gh pr list --limit 50

# Get PR data as JSON
gh pr list --json number,title,headRefName,state
gh pr list --author @me --state open --json number,title,mergeable,statusCheckRollup
```

### View PR Details

```bash
# View PR in terminal
gh pr view <PR_NUMBER>

# Get specific fields as JSON
gh pr view <PR_NUMBER> --json title,body,state,mergeable
gh pr view <PR_NUMBER> --json commits,files,reviews,labels
gh pr view <PR_NUMBER> --json statusCheckRollup,reviewDecision

# Comprehensive PR details
gh pr view <PR_NUMBER> --json number,title,body,state,mergeable,statusCheckRollup,reviews,reviewDecision,headRefName,baseRefName
```

### Create Pull Request

```bash
# Interactive creation
gh pr create

# With title and body
gh pr create --title "Add feature" --body "Description of changes"

# Auto-fill from commits
gh pr create --fill

# Create as draft
gh pr create --draft --title "WIP: Feature" --body "Not ready for review"

# With specific base branch
gh pr create --base develop --title "Hotfix" --body "Emergency fix"
```

### Check PR Status

```bash
# Check CI/CD status
gh pr checks <PR_NUMBER>

# Watch checks in real-time (blocks until complete)
gh pr checks <PR_NUMBER> --watch

# Watch with custom interval
gh pr checks <PR_NUMBER> --watch --interval 5

# Exit on first failure
gh pr checks <PR_NUMBER> --watch --fail-fast
```

### Checkout PR

```bash
# Checkout PR locally
gh pr checkout <PR_NUMBER>

# Get PR branch name
gh pr view <PR_NUMBER> --json headRefName --jq '.headRefName'
```

### Diff PR Changes

```bash
# Show diff
gh pr diff <PR_NUMBER>

# Get changed files list
gh pr view <PR_NUMBER> --json files --jq '.files[].path'
```

## Issue Operations

### List Issues

```bash
# List all open issues
gh issue list --state open

# With filters
gh issue list --label "bug" --state open
gh issue list --assignee @me
gh issue list --search "-label:ai:created"  # Exclude AI-created issues
gh issue list --limit 20

# As JSON
gh issue list --json number,title,labels,state,createdAt
```

### View Issue

```bash
# View in terminal
gh issue view <ISSUE_NUMBER>

# Get JSON data
gh issue view <ISSUE_NUMBER> --json title,body,labels,comments
```

### Create Issue

```bash
# Interactive
gh issue create

# With content
gh issue create --title "Bug report" --body "Description"

# With labels
gh issue create --title "Feature" --body "..." --label "enhancement,priority:high"

# AI-created issues (require human review)
gh issue create --title "..." --body "..." --label "ai:created"
```

### Close Issue

```bash
# Close issue
gh issue close <ISSUE_NUMBER>

# Close with comment
gh issue close <ISSUE_NUMBER> --comment "Fixed in PR #123"
```

## Review Operations

### Submit Review

```bash
# Approve PR
gh pr review <PR_NUMBER> --approve

# Request changes
gh pr review <PR_NUMBER> --request-changes --body "Please address these issues"

# Comment only (no approval)
gh pr review <PR_NUMBER> --comment --body "Looks good overall"

# Approve with body
gh pr review <PR_NUMBER> --approve --body "LGTM! Great work on error handling."
```

### View Reviews

```bash
# Get review data
gh pr view <PR_NUMBER> --json reviews

# Get review decision
gh pr view <PR_NUMBER> --json reviewDecision
```

### Add Comment

```bash
# Add PR comment
gh pr comment <PR_NUMBER> --body "Comment text"

# Add issue comment
gh issue comment <ISSUE_NUMBER> --body "Comment text"
```

### Line-Level Comments (via API)

```bash
# Add line comment to PR
gh api repos/<OWNER>/<REPO>/pulls/<PR_NUMBER>/comments \
  -f body="Comment on this line" \
  -F commit_id="<COMMIT_SHA>" \
  -F path="path/to/file.js" \
  -F line=42

# List all line comments
gh api repos/<OWNER>/<REPO>/pulls/<PR_NUMBER>/comments
```

## Repository Operations

### View Repository

```bash
# View current repo
gh repo view

# Get specific fields
gh repo view --json nameWithOwner,description,defaultBranchRef
gh repo view --json owner,name
```

### List Repositories

```bash
# List all repos for user
gh repo list <USERNAME> --limit 100

# As JSON
gh repo list <USERNAME> --json name,description,updatedAt
```

### Get Repository Info

```bash
# Get owner/repo format
gh repo view --json nameWithOwner --jq '.nameWithOwner'

# Get default branch
gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'
```

## Workflow and Check Operations

### View Workflow Runs

```bash
# List workflow runs
gh run list --limit 20

# View specific run
gh run view <RUN_ID>

# View run logs
gh run view <RUN_ID> --log

# Watch run until completion
gh run watch <RUN_ID>
```

### Rerun Workflows

```bash
# Rerun failed jobs
gh run rerun <RUN_ID> --failed

# Rerun entire workflow
gh run rerun <RUN_ID>
```

## API Operations

### GraphQL Queries

For GraphQL operations, use the github-graphql skill.

Quick reference:

```bash
# Run GraphQL query
gh api graphql --raw-field 'query=...'

# Get PR data
gh api repos/<OWNER>/<REPO>/pulls/<PR_NUMBER>

# Get issue data
gh api repos/<OWNER>/<REPO>/issues/<ISSUE_NUMBER>
```

## JSON Output Processing

### Using jq for Parsing

```bash
# Extract single field
gh pr view <PR_NUMBER> --json state --jq '.state'

# Extract array of values
gh pr list --json number,title --jq '.[] | "\(.number): \(.title)"'

# Filter results
gh pr list --json number,state --jq '.[] | select(.state == "OPEN") | .number'

# Count items
gh pr list --json number --jq '. | length'
```

## Common Patterns

### Check PR Merge-Readiness

```bash
# Get all relevant status
gh pr view <PR_NUMBER> --json state,mergeable,statusCheckRollup,reviewDecision

# Check if mergeable
STATE=$(gh pr view <PR_NUMBER> --json mergeable --jq '.mergeable')
if [ "$STATE" = "MERGEABLE" ]; then
  echo "PR is ready to merge"
fi
```

### Get PR Author

```bash
gh pr view <PR_NUMBER> --json author --jq '.author.login'
```

### List PRs by State

```bash
# Count open PRs
gh pr list --state open --json number --jq '. | length'

# Count closed PRs
gh pr list --state closed --json number --jq '. | length'

# Count merged PRs
gh pr list --state merged --json number --jq '. | length'
```

### Watch CI Until Complete

```bash
# Watch and exit on completion
gh pr checks <PR_NUMBER> --watch

# Store exit code
gh pr checks <PR_NUMBER> --watch
if [ $? -eq 0 ]; then
  echo "All checks passed"
else
  echo "Some checks failed"
fi
```

## Authentication

### Check Auth Status

```bash
# Verify authentication (safe to use in automated agents)
gh auth status

# Check authentication status with scopes (for manual inspection only)
gh auth status --show-token  # WARNING: Exposes token - never use in automation/logs
```

### Login/Logout

```bash
# Login interactively
gh auth login

# Logout
gh auth logout
```

## Error Handling

### Common Errors

| Error | Meaning | Solution |
| ----- | ------- | -------- |
| `HTTP 404: Not Found` | PR/issue doesn't exist | Verify number is correct |
| `HTTP 401: Unauthorized` | Not authenticated | Run `gh auth login` |
| `HTTP 403: Forbidden` | Insufficient permissions | Check repo access |
| `Resource not found` | Invalid owner/repo | Verify repository name |
| `GraphQL error` | Invalid query | Check query syntax |

## Commands Using This Skill

This skill is referenced by:

- `/manage-pr` - PR lifecycle management
- `/review-pr` - PR review operations
- `/fix-pr-ci` - CI check operations
- `/resolve-pr-review-thread` - Review comment handling
- `/shape-issues` - Issue creation/management
- `/resolve-issues` - Issue resolution
- `/ready-player-one` - Repository-wide PR operations
- `/sync-main` - Branch synchronization
- `/auto-claude` - Autonomous orchestration
- Most agents that interact with GitHub

## Best Practices

1. **Always use JSON output** for programmatic parsing (`--json` flag)
2. **Use jq for extraction** instead of parsing text output
3. **Check auth before operations** with `gh auth status`
4. **Use specific field queries** to reduce data transfer
5. Watch commands for long-running ops like `gh pr checks --watch`
6. **Handle errors gracefully** with proper exit code checking
7. **Use `--limit`** when listing to control result size
8. **Filter at query time** rather than post-processing when possible

## Related Skills

- github-graphql skill - GraphQL query patterns
- pr-health-check skill - PR status validation
- pr-thread-resolution-enforcement skill - Review thread resolution
