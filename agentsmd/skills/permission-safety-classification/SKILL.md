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

Bash permission patterns use colon-separated positions. Each segment after the tool name corresponds to one whitespace-separated argument in the shell command. A `*` in any position matches exactly one argument at that position.

- **Wildcard `*` by position**:
  - Pattern `git:*` matches `git` with exactly one argument (any value)
    - Matches: `git status`, `git branch`, `git log`
    - Does NOT match: `git` (no arguments), `git status -sb` (two arguments)
  - Pattern `git:*:*` matches `git` with exactly two arguments (both can be anything)
    - Matches: `git status -sb`, `git branch -a`, `git log --oneline`
    - Does NOT match: `git`, `git status`, `git status -sb --decorate` (three arguments)

- **Command-specific patterns** (literals plus wildcards):
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
