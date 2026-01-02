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

- Root domains cover subdomains: `github.com` includes `api.github.com`
- Different roots are separate: `githubusercontent.com` ≠ `github.com`
- Local/private addresses always DENY
