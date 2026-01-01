---
description: Rebase pull request onto main and push to origin/main (auto-closes PR with signed commits)
model: sonnet
allowed-tools: Task, TaskOutput, Bash(gh:*), Bash(git:*)
---

# Git Rebase Pull Request

Merge the current pull request into main using a local rebase workflow that maintains linear history with signed commits.

## What This Does

1. Validates pull request is ready (open, mergeable, CI passes, approved, threads resolved)
2. Syncs local main with origin/main
3. Rebases pull request branch onto main
4. Fast-forward merges into main
5. Pushes to origin/main with signed commits (auto-closes PR)
6. Cleans up branches and worktree

## Usage

```bash
/git-rebase-pr
```

## Why Not `gh pr merge`?

GitHub's `gh pr merge` command **does not sign commits**, which is incompatible with repositories
requiring commit signatures. This command uses local git operations to maintain proper commit
signing throughout the merge process.

## Full Workflow

See **[Git Rebase Workflow Skill](../skills/git-rebase-workflow/SKILL.md)** for complete step-by-step instructions and edge case handling.

## Prerequisites

- Current branch must have an associated open pull request
- All CI checks must pass on the pull request
- All review threads must be resolved
- Pull request must be approved (or review not required)
- Git configured with commit signing (if required by repository)

## Related

- [GitHub GraphQL Skill](../../../skills/github-graphql/SKILL.md) - PR validation queries
- [Branch Hygiene](../../../rules/branch-hygiene.md) - Rebase vs merge guidance
- [Merge Conflict Resolution](../../../rules/merge-conflict-resolution.md) - Conflict handling
