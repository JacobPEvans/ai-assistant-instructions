---
name: permission-deduplication
description: Use when deduplicating permissions. Identifies redundant patterns covered by broader rules.
version: "1.0.0"
author: "JacobPEvans"
---

# Permission Deduplication

<!-- markdownlint-disable-file MD013 -->

Rules for detecting when a specific permission is already covered by a broader existing pattern.

## Pattern Coverage Rules

### Bash Permissions

Wildcards (`*`) match any value. More wildcards = broader coverage.

**Coverage examples**:

- `git:*:*` covers `git status:*`, `git log:*`, `git diff:*`
- `npm:*:*` covers `npm list:*`, `npm install:*`
- `docker:*:*` covers `docker ps:*`, `docker volume ls:*`
- `*--version:*` covers `npm --version:*`, `docker --version:*`

**No coverage**:

- `git status:*` does NOT cover `git log:*` (different commands)
- `npm:*` does NOT cover `npm:*:*` (different arg counts)

### WebFetch Domains

Root domains cover their subdomains, but different root domains are separate.

**Coverage examples**:

- `github.com` covers `api.github.com`, `docs.github.com`, `status.github.com`
- `docker.com` covers `docs.docker.com`, `hub.docker.com`

**No coverage**:

- `github.com` does NOT cover `githubusercontent.com` (different root domain)
- `github.com` does NOT cover `raw.githubusercontent.com` (separate root, not `raw.github.com`)
- `github.com` does NOT cover `github.io` (different TLD)
- `api.github.com` does NOT cover `docs.github.com` (different subdomains, no root coverage)
- `localhost` does NOT cover `localhost:3000` (port is a distinct entity, not a subdomain)

### File Paths

Broader wildcards cover more specific patterns.

**Coverage examples**:

- `Read(**)` covers any Read permission
- `Glob(**/*)` covers `Glob(**/*.js)`, `Glob(**/package.json)`

## Pattern Notation Clarification

### Bash Permission Argument Counts

Patterns are defined by the number of arguments, where each `:` separates argument positions:

- `git:*` matches `git` with exactly **one** argument (any value)
- `git:*:*` matches `git` with exactly **two** arguments (any values)
- `git status:*` matches `git status` as a command pair, plus exactly **one** additional argument

The notation shows exact argument positions, not whether the command uses the `Bash()` wrapper:

- `Bash(git:*:*)` - Same as `git:*:*`, the `Bash()` wrapper doesn't change the matching rules
- Both match git commands with exactly two arguments where both can be anything

### Deduplication Algorithm Example

When checking if a new permission is already covered by an existing one, validate argument counts match:

```python
def is_covered(existing_pattern, new_pattern):
    # Extract components
    existing_cmd, *existing_args = existing_pattern.split(':')
    new_cmd, *new_args = new_pattern.split(':')

    # Commands must match
    if existing_cmd != new_cmd:
        return False

    # Argument counts must be identical (otherwise patterns aren't comparable)
    if len(existing_args) != len(new_args):
        return False

    # Each position: existing must be "*" or match exactly
    return all(
        existing_arg == "*" or existing_arg == new_arg
        for existing_arg, new_arg in zip(existing_args, new_args)
    )
```

## Root Domain Recommendations

For well-known vendors (GitHub, Docker, Google, Apple, Microsoft), prefer root domain over individual subdomains.

If multiple subdomains found → suggest adding root domain instead.

## Related Permission Suggestions

When discovering a safe permission, suggest related safe commands in the same family:

- `docker volume ls` → suggest `docker volume inspect`
- `aws s3 ls` → suggest `aws s3 sync --dryrun`
- `npm list` → suggest `npm outdated`, `npm audit`

## Commands Using This Skill

- `.claude/agents/permissions-analyzer.md` - Uses deduplication to filter redundant permissions during discovery
- `/sync-permissions` command - Indirectly uses this skill through the permissions-analyzer agent
