---
description: Fix CI failures across all open PRs in the current repository
model: opus
author: JacobPEvans
allowed-tools: Task, TaskOutput, TodoWrite, Bash(gh:*), Bash(git:*), Read, Glob, Grep
---

# Fix All PR CI Failures

**Purpose**: Systematically resolve all CI failures across all open pull requests in the **current repository** by launching parallel subagents.

## Scope

**CURRENT REPOSITORY ONLY** - This command operates on the repository you're currently in.

What this command DOES:

- Find all open PRs with failing CI in the current repo
- Create worktrees for each failing PR
- Launch parallel subagents (max 5 at once) per PR
- Verify PRs are mergeable
- Clean up worktrees

What this command DOES NOT:

- Cross into other repositories
- Run more than 5 subagents simultaneously

> **Note**: Cross-repo commands have been removed for safety. Run this from each repository individually.

## Subagent Limits

**CRITICAL: Maximum 5 subagents running at once.**

This is a hard limit to prevent token exhaustion and ensure each subagent completes successfully.

### Batching Strategy

If > 5 PRs need processing:

1. Launch first 5 subagents in parallel
2. Wait for ALL 5 to complete using `TaskOutput` with `block=true`
3. Validate each completed - verify PR is mergeable
4. If any incomplete: retry that PR (max 2 retries)
5. Only after all 5 are validated, start next batch of 5
6. Never have more than 5 concurrent subagents

## Execution Steps

### Step 1: Identify Repository

```bash
gh repo view --json nameWithOwner --jq '.nameWithOwner'
```

### Step 2: Find PRs with CI Failures

```bash
gh pr list --json number,headRefName,title,statusCheckRollup,mergeable
```

Filter for PRs where:

- Any check has `conclusion: "FAILURE"`
- OR `mergeable != "MERGEABLE"`

### Step 3: Create Worktrees

For each PR with failures:

```bash
# Sanitize branch name for safe path usage
BRANCH_NAME="<branch-name-from-gh>"
SAFE_BRANCH_DIR="$(printf '%s\n' "$BRANCH_NAME" | tr -c 'A-Za-z0-9._-/' '_')"
git worktree add "$HOME/git/<repo-name>/$SAFE_BRANCH_DIR" "$BRANCH_NAME"
```

### Step 4: Launch Parallel Subagents

Launch subagents in batches of MAX 5.

**Subagent Prompt** (keep concise to save tokens):

```text
Fix CI for PR #{NUMBER} in {OWNER}/{REPO}
Worktree: {PATH}
Branch: {BRANCH}
Failing: {CHECK_NAMES}

Steps:
1. cd {PATH}
2. gh run list --limit 5 --json databaseId,name,conclusion (identify failing run ID)
3. gh run view {RUN_ID} --log-failed (use ID from step 2 to get failure details)
4. Fix root cause (NEVER disable checks)
5. Test locally if possible
6. git commit -m "fix: resolve CI failure"
7. git push

Report: PR#{NUMBER} - FIXED/BLOCKED (reason)
```

### Step 5: Monitor and Validate

Wait for batch completion:

```bash
# For each subagent, use TaskOutput with block=true
```

Verify each PR:

```bash
gh pr view NUMBER --json mergeable,statusCheckRollup
```

PR is complete when `mergeable: "MERGEABLE"` and all checks pass.

### Step 6: Clean Up

```bash
git worktree remove ~/git/<repo-name>/<branch-name>
```

### Step 7: Final Report

```text
## CI Fix Results

Repository: {OWNER}/{REPO}
PRs processed: {N}

FIXED: #{N}, #{N}...
BLOCKED: #{N} (reason)...
```

## GraphQL Patterns

When using GraphQL, always use single-line format:

```bash
# CORRECT: Single-line with --raw-field
gh api graphql --raw-field 'query=query { repository(owner: "OWNER", name: "REPO") { pullRequest(number: N) { mergeable statusCheckRollup { state } } } }'

# INCORRECT: Multi-line causes encoding issues in Claude Code
# gh api graphql -f query='
#   query { ... }
# '
```

## Related Commands

| Command | Scope | Purpose |
| ------- | ----- | ------- |
| `/fix-all-pr-ci` | Current repo, all PRs | Fix all CI failures |
| `/fix-pr-ci` | Current repo, single PR | Fix one PR's CI |
| `/resolve-pr-review-thread-all` | Current repo, all PRs | Address review comments |

## Example Usage

```bash
# From the repository directory
/fix-all-pr-ci
```

---

**Remember**: Current repo only, max 5 subagents, fix root causes, validate completion.
