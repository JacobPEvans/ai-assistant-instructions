# Pull Request Review Guidance

This document consolidates all pull request review instructions and AI reviewer configurations.

## AI Code Reviewers

This repository uses multiple AI assistants for automated code review. Each can be triggered automatically
or manually summoned via PR comments.

### Claude Code

- **Automatic**: Currently disabled. When enabled, reviews PRs on `opened`, `synchronize`,
  `ready_for_review`, and `reopened` events
- **Manual summon**: Comment `@claude` in a PR comment
- **Skip reviews**: Add the `skip-claude` label to the PR
- **Configuration**: `.github/workflows/claude.yml`

### Gemini Code Assist

- **Automatic**: Reviews PRs by default when configured
- **Manual summon**: Comment `/gemini review` in a PR comment
- **Other commands**:
  - `/gemini summary` - Generate a summary of changes
  - `/gemini help` - Show available commands
- **Configuration**: Repository settings or `.gemini/` configuration

### GitHub Copilot

- **Automatic**: Reviews PRs via repository ruleset when configured
- **Manual summon**: Tag `@copilot` in a PR comment
- **Configuration**: Repository rulesets and Copilot settings

### Important Notes

- AI reviewer commands only work in **PR comments**, not in PR descriptions or commit messages
- Multiple AI reviewers can be active simultaneously
- AI feedback should be treated as suggestions - human judgment takes precedence

## PR Workflow Overview

For detailed PR lifecycle management, see [pull-request.md](../commands/pull-request.md).

### Creating a PR

1. **Run local validation**: `markdownlint-cli2 .` and any project-specific linters
2. **Verify clean working directory**: `git status` should show `working tree clean`
3. **Push branch**: `git push -u origin $(git branch --show-current)`
4. **Create PR**: Use the [PR template](../../.github/PULL_REQUEST_TEMPLATE.md)
5. **Link issues**: Include `Closes #<issue-number>` in the PR description

### Review Process

1. **Wait for CI**: `gh pr checks <PR_NUMBER> --watch`
2. **Address feedback**: Fix issues raised by automated checks and reviewers
3. **Resolve conversations**: All review threads must be marked resolved before merge
4. **Request human review**: Only after all checks pass and conversations are resolved

### Review Priority Levels

When providing or responding to feedback, use these priority levels:

- **Required**: Security issues, breaking changes, major bugs - must be fixed
- **Suggested**: Code quality improvements, minor optimizations - should be addressed
- **Optional**: Style preferences, alternative approaches - consider but not required

## Related Commands

- [/pull-request](../commands/pull-request.md) - Complete PR lifecycle management
- [/rok-review-pr](../commands/rok-review-pr.md) - Comprehensive PR review workflow
- [/rok-respond-to-reviews](../commands/rok-respond-to-reviews.md) - Respond to PR feedback
- [/review-code](../commands/review-code.md) - Code review guidelines
- [/review-docs](../commands/review-docs.md) - Documentation review guidelines

## GraphQL Thread Resolution

To programmatically resolve PR review threads, see
[pull-request-review-feedback.md](../commands/pull-request-review-feedback.md).

Quick reference:

```bash
# Get all review threads
gh api graphql -f query='{
  repository(owner: "OWNER", name: "REPO") {
    pullRequest(number: 123) {
      reviewThreads(first: 50) {
        nodes { id isResolved comments(first: 5) { nodes { body path line } } }
      }
    }
  }
}'

# Resolve a thread
gh api graphql -f query='mutation {
  resolveReviewThread(input: {threadId: "PRRT_xxx"}) {
    thread { isResolved }
  }
}'
```
