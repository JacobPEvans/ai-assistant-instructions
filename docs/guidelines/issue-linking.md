# Issue Linking Guidelines

This document defines the standard process for linking GitHub Issues to Pull Requests and commits.

## Overview

When implementing work for a GitHub issue, bidirectional linking is required to maintain traceability and enable automatic issue closure.

## Branch Naming

Include the issue number in your branch name:

- **Feature**: `feature/issue-<number>-<brief-description>`
- **Bug fix**: `fix/issue-<number>-<brief-description>`
- **Docs**: `docs/issue-<number>-<brief-description>`

**Examples**:

- `feature/issue-123-add-caching`
- `fix/issue-456-auth-timeout`
- `docs/issue-789-api-reference`

## PR Description

Always include the issue reference in your PR description using GitHub's automatic closure keywords:

- Use `Closes #<issue-number>` for features and enhancements
- Use `Fixes #<issue-number>` for bug fixes
- Use `Resolves #<issue-number>` for general issues

Fill in the "Related Issue" section of the PR template with the appropriate keyword and issue number.

**Why this matters**: GitHub automatically closes the linked issue when the PR is merged, ensuring issues don't remain open after completion.

## Commit Messages

Include the issue reference in commit messages, especially the final commit:

```bash
git commit -m "feat: implement caching layer

Detailed description of changes:
- Added Redis caching service
- Implemented cache invalidation
- Added cache metrics

Closes #123"
```

Use conventional commit prefixes:

- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation
- `refactor:` for code improvements
- `test:` for test additions

## Bidirectional Link (Issue Comment)

After creating the PR, comment on the issue to create visibility:

```bash
gh issue comment <issue-number> --body "Implementation PR: #<pr-number>"
```

**Why this matters**: This allows stakeholders watching the issue to see progress immediately without navigating to the PR list.

## Complete Workflow

| When | Action |
| ---- | ------ |
| Creating branch | Include issue number in branch name |
| Creating PR | Add `Closes #<issue-number>` to description |
| After PR created | Comment on issue with PR link |
| PR merged | Issue auto-closes via GitHub |

## Examples

### Single Issue Implementation

```bash
# 1. Create branch with issue number
git checkout -b fix/issue-42-cache-timeout

# 2. Make changes and commit
git commit -m "fix: resolve cache timeout issue

Closes #42"

# 3. Push and create PR
git push -u origin fix/issue-42-cache-timeout
gh pr create --title "Fix cache timeout" --body "Closes #42"

# 4. Add bidirectional link
gh issue comment 42 --body "Implementation PR: #123"
```

### Multiple Related Issues

When a PR addresses multiple related issues:

```bash
# PR description should list all issues:
Closes #42
Closes #43
Resolves #44
```

## Automation Support

These conventions enable:

- **Automatic issue closure** when PR is merged
- **Traceability** between issues and implementation
- **Progress visibility** for issue stakeholders
- **Release notes generation** from commit messages
- **Project tracking** via issue/PR relationships
