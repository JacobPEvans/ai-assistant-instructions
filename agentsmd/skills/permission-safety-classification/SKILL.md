---
title: "Permission Safety Classification"
description: "Rules for classifying permissions as allow/ask/deny based on operation type and risk"
version: "1.0.0"
author: "JacobPEvans"
---

<!-- markdownlint-disable-file MD013 -->

Classification rules for evaluating permission safety. Use these criteria to categorize permissions consistently.

## Classification Rules

### ALLOW - Read-Only and Safe Operations

Keywords: `list`, `ls`, `show`, `info`, `view`, `get`, `describe`, `inspect`, `status`, `doctor`, `ping`, `check`, `--version`, `--help`

Safe domains: github.com, docker.com, kubernetes.io, python.org, npmjs.com, official documentation sites

### ASK - Modifications and Risky Operations

Keywords: `update`, `set`, `edit`, `patch`, `modify`, `apply`, `rm`, `delete`, `remove`, `prune`, `clean`, `exec`, `run`, `eval`, `push`, `publish`, `deploy`, `kill`, `stop`

Requires user confirmation before execution.

### DENY - Irreversible Damage or Security Bypass

Keywords: `sudo`, `chmod 777`, `dd`, file patterns like `**/.env`, `**/*_rsa`, `**/*.key`, `**/*secret*`

Local addresses: `localhost`, `127.0.0.1`, private IP ranges

## Decision Criteria

1. **Read-only query + no secrets** → ALLOW
2. **Modifies resources + reversible** → ASK
3. **Irreversible or security risk** → DENY
4. **Uncertain** → ASK (conservative default)

## Domain Coverage

Root domains cover their subdomains, but different root domains or TLDs are separate:

- **`github.com`** covers: `api.github.com`, `docs.github.com`, `status.github.com`
- **`github.io`** is a separate root domain (different TLD), does NOT cover `github.com` and vice versa
- **`github.com`** does NOT cover `githubusercontent.com` (separate root domain)
- **`localhost`** is separate from `localhost:3000` (ports are distinct entities, not subdomains)

Local/private addresses always DENY:

- `localhost`, `127.0.0.1`, `192.168.x.x`, `10.x.x.x` ranges

## Bash Permission Format

Bash permission patterns use colon-separated argument positions where `*` matches any single argument at that position:

- **Wildcard `*`**: Matches any single argument at that position
  - `git:*:*` matches `git` with exactly two arguments (both can be anything)
  - More general than `git:*` (which matches `git` with exactly one argument)

- **Command-specific patterns**:
  - `Bash(git status:*)` - `git status` with exactly one additional argument (any)
  - `Bash(git:*:*)` - `git` with exactly two arguments (any)
  - `Bash(npm list:*)` - `npm list` with exactly one additional argument
  - `Bash(npm:*:*)` - `npm` with exactly two arguments (any)
