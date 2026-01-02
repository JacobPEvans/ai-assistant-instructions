---
title: "Permission Deduplication"
description: "Pattern matching rules to identify redundant permissions covered by broader patterns"
version: "1.0.0"
author: "JacobPEvans"
---

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

- `github.com` covers `api.github.com`, `docs.github.com`, `raw.github.com`
- `docker.com` covers `docs.docker.com`, `hub.docker.com`

**No coverage**:

- `github.com` does NOT cover `githubusercontent.com` (different root)
- `github.com` does NOT cover `github.io` (different TLD)
- `api.github.com` does NOT cover `docs.github.com` (different subdomains, no root)

### File Paths

Broader wildcards cover more specific patterns.

**Coverage examples**:

- `Read(**)` covers any Read permission
- `Glob(**/*)` covers `Glob(**/*.js)`, `Glob(**/package.json)`

## Root Domain Recommendations

For well-known vendors (GitHub, Docker, Google, Apple, Microsoft), prefer root domain over individual subdomains.

If multiple subdomains found → suggest adding root domain instead.

## Related Permission Suggestions

When discovering a safe permission, suggest related safe commands in the same family:

- `docker volume ls` → suggest `docker volume inspect`
- `aws s3 ls` → suggest `aws s3 sync --dryrun`
- `npm list` → suggest `npm outdated`, `npm audit`
