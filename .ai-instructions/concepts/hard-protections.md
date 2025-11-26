# Concept: Hard Protections

This document defines inviolable safety constraints that apply to all AI agents regardless of mode, instructions, or context. These protections cannot be overridden.

## Core Principle: Safety Over Speed

```text
Hard protections exist because some mistakes are irreversible.
A delayed task is recoverable. A deleted test suite is not.
When in doubt, PROTECT.
```

## Protection Categories

### 1. Validation Step Protections

**NEVER** circumvent validation mechanisms:

| Protection | Violation Examples | Why It Matters |
|------------|-------------------|----------------|
| Pre-commit hooks | `git commit --no-verify` | Bypasses quality checks |
| GitHub Actions | Deleting `.github/workflows/` | Removes CI/CD safety net |
| Linter configs | Deleting `.eslintrc`, `.prettierrc` | Removes code quality enforcement |
| Type checking | `// @ts-ignore` everywhere | Hides type errors |
| Test requirements | Removing test coverage thresholds | Allows untested code |

### 2. Test Protections

**NEVER** remove or weaken tests:

| Action | Allowed | Not Allowed |
|--------|---------|-------------|
| Add new tests | Always | - |
| Modify test to match new behavior | Yes, if behavior change is intentional | - |
| Delete failing test | Never | Deleting to make CI pass |
| Skip tests | Never | `describe.skip()`, `@pytest.mark.skip` |
| Disable test file | Never | Removing from test runner config |
| Reduce coverage thresholds | Never | Lowering required % |

**Exception:** Tests MAY be modified if:

1. The underlying feature was intentionally removed
2. The test itself has a bug (fix the test, don't delete)
3. Test is duplicated (consolidate, don't delete)

### 3. Security Protections

**NEVER** weaken security:

| Protection | Violation Examples |
|------------|-------------------|
| Authentication | Removing auth middleware |
| Authorization | Bypassing permission checks |
| Input validation | Removing sanitization |
| Secrets management | Hardcoding credentials |
| HTTPS enforcement | Allowing HTTP in production |
| CORS restrictions | Setting `Access-Control-Allow-Origin: *` |

### 4. Data Protections

**NEVER** risk data loss:

| Protection | Violation Examples |
|------------|-------------------|
| Backups | Deleting backup scripts |
| Migrations | `DROP TABLE` without backup |
| Cascading deletes | `ON DELETE CASCADE` without review |
| Truncation | `TRUNCATE TABLE` in production |

### 5. Git Protections

**NEVER** corrupt git history:

| Protection | Violation Examples |
|------------|-------------------|
| Force push | `git push --force` to shared branches |
| History rewrite | `git rebase` on pushed commits |
| Protected branches | Direct push to main/master |
| Hook bypass | `--no-verify` flag |

## Detection Mechanisms

### Pre-Action Checks

Before executing any file modification, check for:

```python
PROTECTED_PATTERNS = [
    # Pre-commit hooks
    r'\.husky/',
    r'\.git/hooks/',
    r'pre-commit-config\.yaml',

    # CI/CD
    r'\.github/workflows/',
    r'\.gitlab-ci\.yml',
    r'Jenkinsfile',
    r'\.circleci/',

    # Linting
    r'\.eslintrc',
    r'\.prettierrc',
    r'\.pylintrc',
    r'tslint\.json',
    r'\.flake8',

    # Testing
    r'jest\.config',
    r'pytest\.ini',
    r'\.coveragerc',
    r'karma\.conf',
]

DANGEROUS_OPERATIONS = [
    r'--no-verify',
    r'--force',
    r'@ts-ignore',
    r'@ts-nocheck',
    r'eslint-disable',
    r'prettier-ignore',
    r'describe\.skip',
    r'it\.skip',
    r'pytest\.mark\.skip',
    r'DROP TABLE',
    r'TRUNCATE',
    r'DELETE FROM .* WHERE 1',
]
```

### Commit Review Integration

The [Commit Reviewer](../subagents/commit-reviewer.md) subagent enforces hard protections:

1. **Pre-commit scan** - Check for violations before commit
2. **Diff analysis** - Detect deletions of protected files
3. **Pattern matching** - Find dangerous operations in code
4. **BLOCK on violation** - Never auto-approve hard protection violations

## Response to Violations

When a hard protection would be violated:

### 1. Immediate BLOCK

```markdown
## Hard Protection Violation Detected

**Type**: Test Deletion
**File**: src/auth/login.test.ts
**Action Requested**: Delete file
**Status**: BLOCKED

This action violates hard protection rules and cannot proceed.

### Why This Is Protected
Tests can only be added, never removed. Deleting tests to make
CI pass hides bugs rather than fixing them.

### Alternatives
1. Fix the failing test
2. Update test to match intentional behavior change
3. If test is truly obsolete, document why and get explicit approval
```

### 2. Queue for Review

If user explicitly requested the violation:

```markdown
## Hard Protection Override Requested

**Requested By**: User message at [timestamp]
**Type**: Skip pre-commit hooks
**Reason Given**: "Just push it, we'll fix later"

**Status**: Queued for manual override

This action requires explicit confirmation because:
- Pre-commit hooks are a safety net
- Bypassing them risks merging broken code
- "Fix later" often means "never fix"

To proceed: Re-request with explicit acknowledgment of risks
```

### 3. Document Attempt

All violation attempts are logged:

```markdown
## Protection Violation Log

**Timestamp**: 2025-01-15T10:30:00Z
**Task ID**: TASK-XXX
**Type**: Force push attempt
**Target**: main branch
**Action**: BLOCKED
**Resolution**: Created feature branch instead
```

## Override Policy

Hard protections can ONLY be overridden when:

1. **Explicit user instruction** with acknowledgment of risks
2. **Documented in commit message** why override was necessary
3. **Queued follow-up task** to restore protection

Even with override, some actions are NEVER allowed:

- Force push to main/master without backup
- Delete all tests in a project
- Remove all authentication

## Integration

### With User Presence Modes

Hard protections apply in ALL modes:

- `attended`: User sees warning, must acknowledge
- `semi-attended`: BLOCK + notify user
- `unattended`: BLOCK + queue for next session

### With Self-Healing

[Self-Healing](./self-healing.md) does NOT apply to hard protections. These are absolute limits, not guidelines to work around.

### With Commit Reviewer

[Commit Reviewer](../subagents/commit-reviewer.md) is the primary enforcer:

- Scans all commits before merge
- Blocks PRs that violate protections
- Reports violations to orchestrator

### With Autonomous Orchestration

[Autonomous Orchestration](./autonomous-orchestration.md) must respect hard protections even when running unattended overnight.

## Checklist for New Code

Before committing, verify:

- [ ] No `--no-verify` flags in git commands
- [ ] No test files deleted (only added or modified)
- [ ] No pre-commit/CI config files removed
- [ ] No linter disable comments added
- [ ] No security middleware bypassed
- [ ] No hardcoded secrets
- [ ] No force push commands
- [ ] No destructive database operations without safeguards
