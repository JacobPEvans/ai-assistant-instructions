---
name: permission-patterns
description: Rules for evaluating, classifying, and deduplicating AI tool permissions
version: "1.0.0"
author: "JacobPEvans"
---

# Permission Patterns

<!-- markdownlint-disable-file MD013 -->

Unified patterns for permission safety classification and deduplication. Use these rules to evaluate permissions consistently.

## Safety Classification

Classification rules for evaluating permission safety. Use these criteria to categorize permissions consistently.

### Classification Rules

#### ALLOW - Read-Only and Safe Operations

Keywords: `list`, `ls`, `show`, `info`, `view`, `get`, `describe`, `inspect`, `status`, `doctor`, `ping`, `check`, `--version`, `--help`

Safe domains: github.com, docker.com, kubernetes.io, python.org, npmjs.com, official documentation sites

#### ASK - Modifications and Risky Operations

Keywords: `update`, `set`, `edit`, `patch`, `modify`, `apply`, `rm`, `delete`, `remove`, `prune`, `clean`, `exec`, `run`, `eval`, `push`, `publish`, `deploy`, `kill`, `stop`

Requires user confirmation before execution.

#### DENY - Irreversible Damage or Security Bypass

Keywords: `sudo`, `chmod 777`, `dd`, file patterns like `**/.env`, `**/*_rsa`, `**/*.key`, `**/*secret*`

Local addresses: `localhost`, `127.0.0.1`, private IP ranges

### Decision Criteria

1. **Read-only query + no secrets** → ALLOW
2. **Modifies resources + reversible** → ASK
3. **Irreversible or security risk** → DENY
4. **Uncertain** → ASK (conservative default)

### Domain Coverage

Root domains cover their subdomains, but different root domains or TLDs are separate:

- **`github.com`** covers: `api.github.com`, `docs.github.com`, `status.github.com`
- **`github.io`** is a separate root domain (different TLD), does NOT cover `github.com` and vice versa
- **`github.com`** does NOT cover `githubusercontent.com` (separate root domain)
- **`localhost`** is separate from `localhost:3000` (ports are distinct entities, not subdomains)

Local/private addresses always DENY:

- `localhost`, `127.0.0.1`, `192.168.x.x`, `10.x.x.x` ranges

---

## Pattern Deduplication

Rules for detecting when a specific permission is already covered by a broader existing pattern.

### Pattern Coverage Rules

#### Bash Permissions

Wildcards (`*`) match any value. More wildcards = broader coverage.

**Coverage examples**:

- `git:*:*` covers `git status:*`, `git log:*`, `git diff:*`
- `npm:*:*` covers `npm list:*`, `npm install:*`
- `docker:*:*` covers `docker ps:*`, `docker volume ls:*`
- `*--version:*` covers `npm --version:*`, `docker --version:*`

**No coverage**:

- `git status:*` does NOT cover `git log:*` (different commands)
- `npm:*` does NOT cover `npm:*:*` (different arg counts)

#### WebFetch Domains

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

#### File Paths

Broader wildcards cover more specific patterns.

**Coverage examples**:

- `Read(**)` covers any Read permission
- `Glob(**/*)` covers `Glob(**/*.js)`, `Glob(**/package.json)`

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

### Root Domain Recommendations

For well-known vendors (GitHub, Docker, Google, Apple, Microsoft), prefer root domain over individual subdomains.

If multiple subdomains found → suggest adding root domain instead.

### Related Permission Suggestions

When discovering a safe permission, suggest related safe commands in the same family:

- `docker volume ls` → suggest `docker volume inspect`
- `aws s3 ls` → suggest `aws s3 sync --dryrun`
- `npm list` → suggest `npm outdated`, `npm audit`

---

## Bash Permission Format

Bash permission patterns use colon-separated positions. Each segment after the tool name corresponds to one whitespace-separated argument in the shell command. A `*` in any position matches exactly one argument at that position.

### Wildcard `*` by position

- Pattern `git:*` matches `git` with exactly one argument (any value)
  - Matches: `git status`, `git branch`, `git log`
  - Does NOT match: `git` (no arguments), `git status -sb` (two arguments)
- Pattern `git:*:*` matches `git` with exactly two arguments (both can be anything)
  - Matches: `git status -sb`, `git branch -a`, `git log --oneline`
  - Does NOT match: `git`, `git status`, `git status -sb --decorate` (three arguments)

### Command-specific patterns (literals plus wildcards)

- Pattern `git:status:*` (written as `Bash(git status:*)`) matches `git status` with exactly one additional argument
  - Matches: `git status -sb`, `git status --short`
  - Does NOT match: `git status` (no extra argument), `git branch -a`
- Pattern `git:*:*` (written as `Bash(git:*:*)`) matches any `git <subcommand> <arg>`
  - Matches: `git status -sb`, `git branch -a`, `git log --oneline`
- Pattern `npm:list:*` (written as `Bash(npm list:*)`) matches `npm list` with exactly one additional argument
  - Matches: `npm list --depth=0`
  - Does NOT match: `npm list` (no extra argument), `npm install express`
- Pattern `npm:*:*` (written as `Bash(npm:*:*)`) matches any `npm <subcommand> <arg>`
  - Matches: `npm list --depth=0`, `npm install express`

### Pattern Notation Clarification

Patterns are defined by the number of arguments, where each `:` separates argument positions:

- `git:*` matches `git` with exactly **one** argument (any value)
- `git:*:*` matches `git` with exactly **two** arguments (any values)
- `git status:*` matches `git status` as a command pair, plus exactly **one** additional argument

The notation shows exact argument positions, not whether the command uses the `Bash()` wrapper:

- `Bash(git:*:*)` - Same as `git:*:*`, the `Bash()` wrapper doesn't change the matching rules
- Both match git commands with exactly two arguments where both can be anything

---

## Commands Using This Skill

- `.claude/agents/permissions-analyzer.md` - Uses classification and deduplication to filter permissions during discovery
- `/sync-permissions` command - Indirectly uses this skill through the permissions-analyzer agent
