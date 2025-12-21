# Issue Resolver

Automated GitHub Actions workflow that uses Claude AI to analyze issues and apply intelligent labels based on content analysis.

## Overview

The Issue Resolver workflow automatically:

- **Analyzes issue content** - Uses Claude AI to understand issue titles and descriptions
- **Suggests appropriate labels** - Applies type and priority labels based on analysis
- **Reduces manual effort** - Eliminates manual label assignment for new issues
- **Supports dry-run mode** - Test changes before applying them

## How It Works

The workflow triggers on issue events (opened, edited, reopened) and:

1. Checks out the repository
2. Sends issue title, body, and author to Claude Code Action for analysis
3. Claude determines type and priority labels
4. Labels are applied to the issue (or previewed in dry-run mode)

## Workflow Location

See [`.github/workflows/issue-resolver.yml`](../../.github/workflows/issue-resolver.yml) for the complete workflow definition.

## Configuration

### Available Labels

**Type Labels:**

- `type:feature` - Feature request
- `type:bug` - Bug report
- `type:docs` - Documentation
- `type:question` - Question/discussion

**Priority Labels:**

- `priority:critical` - Urgent, blocks development
- `priority:high` - Important, should be addressed soon
- `priority:medium` - Normal priority
- `priority:low` - Nice-to-have or minor issue

### Dry-Run Mode

Enable dry-run mode to preview label suggestions without modifying issues:

```bash
# When triggering manually via workflow_dispatch
gh workflow run issue-resolver.yml -f dry_run=true
```

In dry-run mode, the workflow logs suggested actions without applying them.

## Example Use Cases

### Case 1: Critical Bug Report

Issue: "App crashes when uploading large files"

Claude Analysis:

- Type: `type:bug` (describes a defect)
- Priority: `priority:critical` (application crash)

Result: Labels `type:bug` and `priority:critical` applied automatically

### Case 2: Documentation Request

Issue: "Add API examples for authentication"

Claude Analysis:

- Type: `type:docs` (requests documentation)
- Priority: `priority:medium` (improves usability but not blocking)

Result: Labels `type:docs` and `priority:medium` applied automatically

### Case 3: Feature Request

Issue: "Add dark mode support"

Claude Analysis:

- Type: `type:feature` (new functionality request)
- Priority: `priority:low` (nice-to-have enhancement)

Result: Labels `type:feature` and `priority:low` applied automatically

## Customizing Label Mappings

To modify the available labels or add custom ones:

1. Edit the `prompt` field in `.github/workflows/issue-resolver.yml`
2. Update the `Available type labels` and `Available priority labels` lists
3. Commit and push changes

Example modification:

```yaml
prompt: |
  Analyze this GitHub issue and suggest appropriate labels.

  Available type labels: type:feature, type:bug, type:docs, type:question, type:enhancement
  Available priority labels: priority:critical, priority:high, priority:medium, priority:low, priority:backlog

  Return labels as JSON: {"labels": ["type:bug", "priority:high"]}
```

## Security Considerations

- **Input Sanitization**: Issue content is passed via environment variables to prevent injection
- **Limited Scope**: Claude Code Action is restricted to `gh issue:*` commands only
- **Rate Limiting**: Max 2 turns (requests) per analysis to control costs
- **Audit Trail**: All label applications appear in issue history and GitHub audit logs

## Troubleshooting

### Workflow Not Triggering

Verify the workflow is enabled:

```bash
gh workflow view issue-resolver.yml
```

### Incorrect Label Suggestions

Review the workflow logs to see Claude's reasoning:

```bash
gh run list --workflow issue-resolver.yml --limit 5
gh run view <run-id> --log
```

### CLAUDE_CODE_OAUTH_TOKEN Not Set

Ensure the `CLAUDE_CODE_OAUTH_TOKEN` secret is configured in repository settings.

## Related Documentation

- [GitHub Actions](https://docs.github.com/en/actions)
- [Claude Code Action](https://github.com/anthropics/claude-code-action)
- [Issue Events](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#issues)
