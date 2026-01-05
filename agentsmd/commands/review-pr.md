---
description: Conduct comprehensive PR reviews with systematic analysis, quality checks, and constructive feedback
model: sonnet
author: roksechs
source: https://gist.github.com/roksechs/3f24797d4b4e7519e18b7835c6d8a2d3
allowed-tools: Task, TaskOutput, Bash(gh:*), Bash(git:*), Bash(npm:*), Read, Grep, Glob, TodoWrite
---

# Review PR

> **Attribution**: This command is from [roksechs](https://gist.github.com/roksechs/3f24797d4b4e7519e18b7835c6d8a2d3)

Comprehensive and systematic Pull Request review system focusing on code quality, architectural consistency, and constructive feedback delivery.

## Scope

**SINGLE PR** - This command reviews one PR at a time, specified by argument or determined from current branch.

> **PR Comment Limit**: This command respects the **50-comment limit per PR** defined in the
> the pr-comment-limits rule.
> If a PR has reached 50 comments, this command will not post new comments. See the rule for details.

### Review Phases

1. **Analyze**: Scope, issue linkage, risks
2. **Quality**: Run automated checks (typecheck, lint, test, build)
3. **Review**: Logic, architecture, tests, docs
4. **Feedback**: Categorize and deliver constructive comments

Apply the code-standards and styleguide rules.

### GitHub CLI Reference

See the github-cli-patterns skill for:

- **PR Information**: `gh pr view`, `gh pr diff`, `gh pr checks`
- **Review Submission**: `gh pr review --approve`, `--request-changes`
- **Line Comments**: via gh API

For local quality checks: `bun run typecheck && bun run test:run && bun run build && bun run lint`

### Review Workflow

1. **Context**: Gather PR details via `gh pr view` (use the github-cli-patterns skill)
2. **Quality**: Checkout with `gh pr checkout`, run local quality checks
3. **Code Review**: Check architecture, code quality, tests, documentation
4. **Comment Limit**: Check 50-comment limit per the pr-comment-limit-enforcement skill
5. **Submit**: Categorize feedback (Critical → Major → Minor → Enhancement), record decision

### Feedback Categories

- 🔴 **Critical** (block merge): Security issues, breaking changes, failed tests
- 🟡 **Major** (request changes): Architecture violations, missing tests
- 🟢 **Minor** (optional): Style, naming, optimizations

### Usage

**Command**: `/review-pr [PR_NUMBER]`

**Workflow**: `/shape-issues` → `/resolve-issues` → `/review-pr` → `/resolve-pr-review-thread`
