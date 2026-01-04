---
title: "Review PR"
description: "Conduct comprehensive PR reviews with systematic analysis, quality checks, and constructive feedback"
model: sonnet
type: "command"
version: "1.0.0"
allowed-tools: Task, TaskOutput, Bash(gh:*), Bash(git:*), Bash(npm:*), Read, Grep, Glob, TodoWrite
think: true
author: "roksechs"
source: "https://gist.github.com/roksechs/3f24797d4b4e7519e18b7835c6d8a2d3"
---

## PR Review Conductor

> **Attribution**: This command is from [roksechs](https://gist.github.com/roksechs/3f24797d4b4e7519e18b7835c6d8a2d3)

Comprehensive and systematic Pull Request review system focusing on code quality, architectural consistency, and constructive feedback delivery.

## Scope

**SINGLE PR** - This command reviews one PR at a time, specified by argument or determined from current branch.

> **PR Comment Limit**: This command respects the **50-comment limit per PR** defined in the
> [PR Comment Limits rule](../rules/pr-comment-limits.md).
> If a PR has reached 50 comments, this command will not post new comments. See the rule for details.

### Review Phases

1. **Analyze**: Scope, issue linkage, risks
2. **Quality**: Run automated checks (typecheck, lint, test, build)
3. **Review**: Logic, architecture, tests, docs
4. **Feedback**: Categorize and deliver constructive comments

Apply [Code Standards](../rules/code-standards.md) and [Styleguide](../rules/styleguide.md).

### GitHub CLI Reference

See [GitHub CLI Patterns](../skills/github-cli-patterns/SKILL.md) for:

- **PR Information**: `gh pr view`, `gh pr diff`, `gh pr checks`
- **Review Submission**: `gh pr review --approve`, `--request-changes`
- **Line Comments**: via gh API

For local quality checks: `bun run typecheck && bun run test:run && bun run build && bun run lint`

### Review Workflow

1. **Context**: Gather PR details via `gh pr view` (see [GitHub CLI Patterns](../skills/github-cli-patterns/SKILL.md))
2. **Quality**: Checkout with `gh pr checkout`, run local quality checks
3. **Code Review**: Check architecture, code quality, tests, documentation
4. **Comment Limit**: Check 50-comment limit per [PR Comment Limit Enforcement](../skills/pr-comment-limit-enforcement/SKILL.md)
5. **Submit**: Categorize feedback (Critical → Major → Minor → Enhancement), record decision

### Feedback Categories

- 🔴 **Critical** (block merge): Security issues, breaking changes, failed tests
- 🟡 **Major** (request changes): Architecture violations, missing tests
- 🟢 **Minor** (optional): Style, naming, optimizations

### Usage

**Command**: `/review-pr [PR_NUMBER]`

**Workflow**: `/shape-issues` → `/resolve-issues` → `/review-pr` → `/resolve-pr-review-thread`
