# Shared GitHub Workflows

This directory contains reusable GitHub Actions workflows that can be centralized and shared across multiple repositories.

## Overview

These workflows are designed to be moved to a dedicated repository (either `JacobPEvans/.github` or `JacobPEvans/shared-workflows`) for organization-wide reuse.

## Workflows Status

⚠️ **Important:** Not all workflows in this directory are currently production-ready.

The following workflows are intentionally **disabled** in the reference implementation using `if: false` and will **not run unless manually enabled** by the user:

| Workflow | Status | Notes |
|--------|--------|------|
| `claude-review.yml` | Disabled | Placeholder for future enablement |
| `issue-triage.yml` | Disabled | Requires additional permissions and tuning |
| `doc-sync.yml` | Disabled | Depends on external documentation infrastructure |
| `markdownlint.yml` | Enabled | Fully functional and safe to use |

Users using these workflows should review, modify, and explicitly enable them as appropriate for their environment.


## Available Workflows

### 1. Claude Code Review (`claude-review.yml`)

Runs Claude Code review on pull requests with configurable parameters.

**Inputs:**

- `max-turns` (number, default: 5) - Maximum turns for Claude Code
- `timeout-minutes` (number, default: 5) - Timeout for the action
- `check-comment-limit` (boolean, default: true) - Check PR comment limit before running
- `comment-limit` (number, default: 50) - Maximum comments before skipping

**Secrets:**

- `CLAUDE_CODE_OAUTH_TOKEN` (required) - Claude Code OAuth token
- `GITHUB_TOKEN` (required) - GitHub token

**Example Usage:**

```yaml
name: Claude Code
on:
  pull_request:
    types: [opened]

jobs:
  review:
    uses: JacobPEvans/.github/.github/workflows/claude-review.yml@main
    secrets:
      CLAUDE_CODE_OAUTH_TOKEN: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### 2. Markdown Lint (`markdownlint.yml`)

Lints markdown files with optional validation.

**Inputs:**

- `globs` (string, default: '\*\*/\*.md') - Glob pattern for files to lint
- `fix` (boolean, default: true) - Auto-fix markdown issues
- `validate-commands` (boolean, default: false) - Run command validation
- `validation-script` (string, default: './scripts/validate-commands.sh') - Script path

**Example Usage:**

```yaml
name: Markdown Lint
on: [push]

jobs:
  lint:
    uses: JacobPEvans/.github/.github/workflows/markdownlint.yml@main
    with:
      validate-commands: true
```

### 3. Issue Triage (`issue-triage.yml`)

Automatically triages new issues using Claude Code.

**Inputs:**

- `max-turns` (number, default: 3) - Maximum turns for Claude Code
- `timeout-minutes` (number, default: 5) - Timeout for the action

**Secrets:**

- `CLAUDE_CODE_OAUTH_TOKEN` (required) - Claude Code OAuth token
- `GITHUB_TOKEN` (required) - GitHub token

**Example Usage:**

```yaml
name: Issue Triage
on:
  issues:
    types: [opened]

jobs:
  triage:
    uses: JacobPEvans/.github/.github/workflows/issue-triage.yml@main
    secrets:
      CLAUDE_CODE_OAUTH_TOKEN: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### 4. Documentation Sync (`doc-sync.yml`)

Checks PR against planning documentation.

**Inputs:**

- `max-turns` (number, default: 5) - Maximum turns for Claude Code
- `timeout-minutes` (number, default: 5) - Timeout for the action
- `planning-file` (string, default: 'PLANNING.md') - Path to planning file

**Secrets:**

- `CLAUDE_CODE_OAUTH_TOKEN` (required) - Claude Code OAuth token
- `GITHUB_TOKEN` (required) - GitHub token

**Example Usage:**

```yaml
name: Documentation Sync
on:
  pull_request:
    types: [opened]

jobs:
  sync:
    uses: JacobPEvans/.github/.github/workflows/doc-sync.yml@main
    secrets:
      CLAUDE_CODE_OAUTH_TOKEN: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Migration Plan

### Phase 1: Create Central Repository (Recommended: `JacobPEvans/.github`)

1. Create a new repository: `JacobPEvans/.github`
2. Copy the `.github-shared/workflows/` directory to `.github/workflows/` in the new repo
3. Commit and push to the `main` branch

### Phase 2: Update Consuming Repositories

Update each repository's workflows to reference the central workflows:

**Before:**

```yaml
name: Claude Code
on:
  pull_request:
    types: [opened]
jobs:
  claude:
    name: "Claude Code Review"
    runs-on: ubuntu-latest
    # ... full workflow definition
```

**After:**

```yaml
name: Claude Code
on:
  pull_request:
    types: [opened]
jobs:
  review:
    uses: JacobPEvans/.github/.github/workflows/claude-review.yml@main
    secrets: inherit
```

### Phase 3: Version Pinning

For production stability, use version tags instead of `@main`:

```yaml
uses: JacobPEvans/.github/.github/workflows/claude-review.yml@v1.0.0
```

## Benefits

- **Single Source of Truth**: One place to update workflows
- **Consistency**: Same behavior across all repositories
- **Easy Maintenance**: Update once, propagate everywhere
- **Version Control**: Pin to specific versions for stability
- **Reduced Duplication**: No more copy-paste between repos

## References

- [GitHub Reusable Workflows](<https://docs.github.com/en/actions/using-workflows/reusing-workflows>)
- [Sharing workflows with your organization][sharing-workflows-link]

[sharing-workflows-link]: https://docs.github.com/en/actions/administering-github-actions/sharing-workflows-secrets-and-runners-with-your-organization
