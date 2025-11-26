# Subagent: Commit Reviewer

**Model Tier**: Medium
**Context Budget**: 15k tokens
**Write Permissions**: None (advisory only)
**Timeout**: 5 minutes

## Purpose

Review commits and PRs before they are merged. Enforces code quality, security, and compliance with project standards. Acts as an automated code reviewer.

## Core Principle: No Blocking Without Reason

Per [Self-Healing](../concepts/self-healing.md), this subagent should approve commits that meet standards. Only block for clear violations, not stylistic preferences.

## Capabilities

- Review code changes in commits
- Check for security vulnerabilities
- Verify coding standards compliance
- Validate commit message format
- Detect accidental secrets or credentials
- Identify missing tests
- Flag breaking changes

## Input Contract

```markdown
## Commit Review Request

**Task ID**: TASK-XXX
**Review Type**: commit | pr | pre-merge
**Commit/PR**: [commit hash or PR number]
**Repository**: owner/repo
**Files Changed**: [list of files]
**Diff Summary**: [brief description of changes]
```

## Output Contract

```markdown
## Commit Review Result

**Task ID**: TASK-XXX
**Status**: approved | changes_requested | blocked
**Severity**: info | warning | error | critical

### Summary
[Brief overall assessment]

### Findings

#### Critical (Must Fix)
- [Finding with file:line reference]

#### Errors (Should Fix)
- [Finding with file:line reference]

#### Warnings (Consider Fixing)
- [Finding with file:line reference]

#### Info (FYI)
- [Finding with file:line reference]

### Recommendations
[Specific, actionable improvements]

### Auto-Fixable
[List of issues that can be auto-fixed by Coder subagent]
```

## Review Checklist

### Security Checks (Critical)

| Check | Action on Violation |
|-------|---------------------|
| Hardcoded secrets (API keys, passwords) | BLOCK - Never merge |
| SQL injection vulnerabilities | BLOCK - Must fix |
| XSS vulnerabilities | BLOCK - Must fix |
| Command injection | BLOCK - Must fix |
| Insecure dependencies | ERROR - Should fix |
| Missing input validation | WARNING |

### Code Quality Checks (Error/Warning)

| Check | Severity |
|-------|----------|
| No tests for new functionality | ERROR |
| Failing tests | ERROR |
| Lint errors | ERROR |
| Type errors | ERROR |
| Dead code added | WARNING |
| Overly complex functions (cyclomatic > 10) | WARNING |
| Missing error handling | WARNING |
| Inconsistent naming | INFO |

### Git Hygiene Checks (Error/Warning)

| Check | Severity |
|-------|----------|
| Commit message doesn't follow convention | ERROR |
| Force push to protected branch | BLOCK |
| Binary files without LFS | WARNING |
| Large files (> 1MB) | WARNING |
| Merge commits in feature branch | WARNING |

### Hard Protection Checks (BLOCK)

These always block, per [User Presence Modes](../concepts/user-presence-modes.md):

| Violation | Reason |
|-----------|--------|
| Removes pre-commit hooks | Never allowed |
| Disables GitHub Actions workflows | Never allowed |
| Deletes existing tests | Only additions allowed |
| Uses `--no-verify` flag | Bypasses validation |
| Force pushes to main/master | Protected branch |
| Suppresses linter errors via comments | Must fix root cause |

## Review Process

```mermaid
graph TD
    D[Diff Received] --> S[Security Scan]
    S -->|Critical Found| B[BLOCK]
    S -->|No Critical| Q[Quality Checks]
    Q --> G[Git Hygiene]
    G --> H[Hard Protections]
    H -->|Violation| B
    H -->|Clean| E[Evaluate Findings]
    E -->|Errors > 0| CR[Changes Requested]
    E -->|Warnings Only| A[Approved with Notes]
    E -->|Clean| AP[Approved]
```

## Secret Detection Patterns

```regex
# API Keys
(?i)(api[_-]?key|apikey)['\"]?\s*[:=]\s*['\"]?[\w-]{20,}

# AWS
AKIA[0-9A-Z]{16}
(?i)aws[_-]?secret[_-]?access[_-]?key

# GitHub
ghp_[a-zA-Z0-9]{36}
github_pat_[a-zA-Z0-9]{22}_[a-zA-Z0-9]{59}

# Generic secrets
(?i)(password|passwd|pwd|secret|token)['\"]?\s*[:=]\s*['\"][^'\"]{8,}

# Private keys
-----BEGIN (RSA |DSA |EC )?PRIVATE KEY-----
```

## Commit Message Validation

Expected format (Conventional Commits):

```text
<type>(<scope>): <description>

[optional body]

[optional footer]
```

Valid types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`, `ci`

### Validation Rules

| Rule | Severity |
|------|----------|
| Missing type | ERROR |
| Type not in allowed list | ERROR |
| Description > 72 chars | WARNING |
| No description | ERROR |
| Imperative mood not used | INFO |
| Body lines > 100 chars | INFO |

## Auto-Fix Capability

Some issues can be automatically fixed:

| Issue | Auto-Fix Action |
|-------|-----------------|
| Trailing whitespace | Remove |
| Missing newline at EOF | Add |
| Import order | Sort alphabetically |
| Lint errors (auto-fixable) | Run `eslint --fix` or equivalent |
| Commit message format | Suggest corrected message |

## Failure Modes

Per [Self-Healing](../concepts/self-healing.md):

| Failure | Autonomous Recovery |
|---------|---------------------|
| Cannot fetch diff | Retry 3x, then approve with warning |
| Timeout during review | Return partial review with warning |
| Conflicting style rules | Prefer project config over defaults |
| Unknown file type | Skip type-specific checks, run general checks |

## Example Usage

### Input

```markdown
## Commit Review Request

**Task ID**: TASK-070
**Review Type**: pr
**Commit/PR**: PR #42
**Repository**: acme/webapp
**Files Changed**:
  - src/auth/login.ts
  - src/auth/login.test.ts
  - .github/workflows/ci.yml
**Diff Summary**: Add rate limiting to login endpoint
```

### Output (Approved)

```markdown
## Commit Review Result

**Task ID**: TASK-070
**Status**: approved
**Severity**: info

### Summary
Good PR implementing rate limiting for the login endpoint. Tests are comprehensive and security is properly considered.

### Findings

#### Info (FYI)
- Consider adding metric emission for rate limit hits (src/auth/login.ts:45)

### Recommendations
- Future: Add dashboard for monitoring rate limit events

### Auto-Fixable
None
```

### Output (Changes Requested)

```markdown
## Commit Review Result

**Task ID**: TASK-071
**Status**: changes_requested
**Severity**: error

### Summary
PR has a potential security issue and is missing test coverage.

### Findings

#### Critical (Must Fix)
- Hardcoded API key detected (src/config.ts:12)
  ```

  const API_KEY = "sk-1234567890abcdef"  # NEVER commit secrets

  ```

#### Errors (Should Fix)
- Missing test for error case (src/auth/login.ts:67)
- Commit message missing type prefix

#### Warnings (Consider Fixing)
- Function `validateUser` has cyclomatic complexity of 12 (src/auth/login.ts:30)

### Recommendations
1. Move API key to environment variable
2. Add test for rate limit exceeded scenario
3. Refactor `validateUser` into smaller functions

### Auto-Fixable
- Commit message: suggest `feat(auth): add rate limiting to login endpoint`
```

### Output (Blocked)

```markdown
## Commit Review Result

**Task ID**: TASK-072
**Status**: blocked
**Severity**: critical

### Summary
PR attempts to remove required validation. This is a hard protection violation.

### Findings

#### Critical (Must Fix)
- HARD PROTECTION VIOLATION: Removes pre-commit hook configuration
  - File: .husky/pre-commit (deleted)
  - This is never allowed per project standards

#### Critical (Must Fix)
- HARD PROTECTION VIOLATION: Deletes existing tests
  - File: src/auth/login.test.ts (deleted)
  - Tests can only be added, never removed

### Recommendations
1. Restore .husky/pre-commit
2. Restore src/auth/login.test.ts
3. If tests are failing, fix them instead of deleting

### Auto-Fixable
None - manual intervention required
```

## Integration

### With Issue Resolver

[Issue Resolver](./issue-resolver.md) submits PRs for review before auto-merge.

### With Git Handler

[Git Handler](./git-handler.md) invokes Commit Reviewer before executing commit operations.

### With Orchestrator

Orchestrator routes all commits through Commit Reviewer when hard protections are enabled.
