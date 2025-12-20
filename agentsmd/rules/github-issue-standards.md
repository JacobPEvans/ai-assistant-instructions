# GitHub Issue Standards

This document defines best practices for creating, managing, and resolving GitHub issues in this repository.

## Issue Creation Command

**Always use `/shape-issues`** when creating GitHub issues. This command implements Shape Up methodology and ensures issues are well-formed before creation.

## Title Conventions

Use prefixes to categorize issues:

| Prefix          | Use Case                | Example                                     |
| --------------- | ----------------------- | ------------------------------------------- |
| `[FEATURE]`     | New functionality       | `[FEATURE] Add dark mode support`           |
| `[BUG]`         | Something broken        | `[BUG] Login fails on Safari`               |
| `[DOCS]`        | Documentation changes   | `[DOCS] Update API reference`               |
| `[REFACTOR]`    | Code improvements       | `[REFACTOR] Simplify auth logic`            |
| `[Small Batch]` | Scoped 1-2 week work    | `[Small Batch] Improve error messages`      |

## Label Taxonomy

### Type Labels (required - pick one)

- `bug` - Something isn't working
- `enhancement` - New feature or improvement
- `documentation` - Documentation changes
- `question` - Needs clarification

### Priority Labels (required - pick one)

- `priority: critical` - Urgent, blocks other work
- `priority: high` - Important, address soon
- `priority: medium` - Normal priority
- `priority: low` - Address when time permits

### Status Labels (add as appropriate)

- `ready-for-dev` - Shaped and ready for `/resolve-issues`
- `help wanted` - Open for contributors
- `good first issue` - Suitable for newcomers

### Timebox Labels (for shaped issues)

- `timebox:small-batch` - 1-2 week scope
- `timebox:big-batch` - 6 week scope
- `timebox:spike` - Investigation/research

## Issue Body Structure

### Feature Requests

Follow the Shape Up template from `/shape-issues`:

```markdown
## Problem

**Raw idea**: [Initial concept or user complaint]
**Current pain**: [What's broken or frustrating]
**Timebox**: [Small batch | Big batch | Spike]

## Solution Sketch

**Core concept**: [High-level approach]
**Key elements**: [Main components]
**Out of scope**: [What we're NOT doing]

## Rabbit Holes

- [Complexity trap to avoid]
- [Scope creep risk]

## Done Looks Like

- [ ] Acceptance criterion 1
- [ ] Acceptance criterion 2

## Verification Steps

- [ ] How to verify criterion 1
- [ ] How to verify criterion 2

## Metadata

**Related Issues**:
- Blocks: #XX
- Blocked by: #YY
- Related to: #ZZ
```

### Bug Reports

```markdown
## What Happened

[Expected vs actual behavior]

## Steps to Reproduce

1. Step one
2. Step two
3. Step three

## Context

- **Environment**: [OS, browser, tool version]
- **File/Command**: [If applicable]

## Done Looks Like

- [ ] Bug no longer occurs
- [ ] Regression test added

## Verification Steps

- [ ] Reproduce steps no longer trigger bug
- [ ] Run test suite

## Metadata

**Related Issues**:
- Blocks: #XX
- Blocked by: #YY
- Related to: #ZZ
```

## Metadata Best Practices

### Assignees

- Assign to yourself if you're committing to work on it
- Leave unassigned if seeking contributors
- For team repos, assign based on expertise

### Milestones

- Use for release planning
- Group related issues by target version
- Example: `v1.2.0`, `Q1 2025`

### Projects

- Add to project boards for kanban tracking
- Use for sprint planning
- Enables progress visualization

### Related Issues

Always link related issues:

```markdown
## Related Issues

- Blocks: #45
- Blocked by: #42
- Related to: #38, #39
```

## Acceptance Criteria

**Every issue MUST have explicit acceptance criteria.**

Good acceptance criteria are:

- **Specific**: Clearly defined, not vague
- **Measurable**: Can verify pass/fail
- **Checkboxes**: Use `- [ ]` format for tracking

Example:

```markdown
## Done Looks Like

- [ ] API endpoint returns 200 for valid requests
- [ ] Error messages include error codes
- [ ] Documentation updated with new endpoint
- [ ] Unit tests cover happy path and error cases
```

## Verification Steps

**Every issue SHOULD have verification steps.**

These are distinct from acceptance criteria - they describe HOW to verify:

```markdown
## Verification Steps

- [ ] Run `npm test` - all tests pass
- [ ] Manual test: create new user, verify redirect
- [ ] Check logs for error messages
- [ ] Review Lighthouse score (target: 90+)
```

## Anti-Patterns to Avoid

| Anti-Pattern           | Problem                    | Better Approach                              |
| ---------------------- | -------------------------- | -------------------------------------------- |
| Vague titles           | "Fix stuff"                | "[BUG] Login button unresponsive on mobile"  |
| No acceptance criteria | Can't verify done          | Add "Done Looks Like" section                |
| Missing labels         | Hard to filter/prioritize  | Add type + priority labels                   |
| Scope creep            | Issue grows unbounded      | Define "Out of scope" section                |
| No timebox             | Work expands indefinitely  | Set small/big batch timebox                  |

## Integration with Commands

| Action | Command |
| ------ | ------- |
| Create/shape issues | `/shape-issues` |
| Implement issues | `/resolve-issues` |
| Review resulting PR | `/review-pr` |
| Resolve PR feedback | `/resolve-pr-review-thread` |

## PR-Issue Linking

When implementing work for a GitHub issue, bidirectional linking is required.

### Branch Naming

Include the issue number in your branch name:

- Feature: `feature/issue-{number}-{brief-description}`
- Bug fix: `fix/issue-{number}-{brief-description}`
- Docs: `docs/issue-{number}-{brief-description}`

### PR Description

Always include the issue reference in your PR description:

- Use `Closes #<issue-number>` or `Fixes #<issue-number>` for automatic closure
- Fill in the "Related Issue" section of the PR template

### Issue Comment (Bidirectional Link)

After creating the PR, comment on the issue to create visibility:

```bash
gh issue comment {issue-number} --body "Implementation PR: #<pr-number>"
```

This allows stakeholders watching the issue to see progress immediately.

### Workflow Integration

| When | Action |
| ---- | ------ |
| Creating branch | Include issue number in branch name |
| Creating PR | Add `Closes #<issue-number>` to description |
| After PR created | Comment on issue with PR link |
| PR merged | Issue auto-closes via GitHub |
