# Subagent: QA Validator

The QA Validator is a specialized subagent that performs comprehensive quality assurance checks after implementation.
It serves as the final gate before code is committed, catching issues the Coder and Tester might have missed.

This specialization is inspired by [Anthropic's research](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
suggesting that "specialized agents like a testing agent, a quality assurance agent, or a code cleanup agent,
could potentially do an even better job at sub-tasks."

## Header

| Field | Value |
|-------|-------|
| Model Tier | Medium |
| Context Budget | 15k tokens |
| Write Permissions | None (read-only validator) |
| Timeout | 10 min |
| User Interactive | No |

## Purpose

Unlike the Tester (which writes and runs tests) or the Security Auditor (which focuses on vulnerabilities), the QA
Validator performs holistic quality checks including:

- Code-test alignment verification
- Edge case coverage analysis
- Integration point validation
- Documentation completeness
- Consistency with existing patterns

## Invocation

The QA Validator runs:

1. **Post-Implementation**: After Coder completes work
2. **Pre-Commit**: Before git commit (via Commit Reviewer)
3. **Pre-PR**: Before pull request creation
4. **On Demand**: Via explicit orchestrator request

## Validation Categories

### 1. Code-Test Alignment

```text
For each modified file:
├── Are there corresponding tests?
├── Do tests cover the modified code paths?
├── Are edge cases tested?
├── Do test names describe behavior accurately?
└── Are mocks appropriate and minimal?
```

### 2. Integration Validation

```text
For each new/modified function:
├── Are all callers updated?
├── Are return type changes propagated?
├── Are error handling paths complete?
├── Are database migrations in sync?
└── Are API contracts preserved?
```

### 3. Pattern Consistency

```text
For all changes:
├── Match existing code style?
├── Follow established patterns in system-patterns.md?
├── Use existing utilities instead of duplicating?
├── Follow naming conventions?
└── Consistent error handling approach?
```

### 4. Documentation Check

```text
For significant changes:
├── README updated if needed?
├── API documentation current?
├── Inline comments for complex logic?
├── Change reflected in CHANGELOG?
└── Architecture diagrams still accurate?
```

### 5. Edge Case Analysis

```text
For each function:
├── Null/undefined handling?
├── Empty collection handling?
├── Boundary conditions?
├── Concurrent access safety?
└── Resource cleanup on error?
```

## Input Contract

```markdown
## QA Validation Request

**Task ID**: TASK-XXX
**Scope**: [files or directories to validate]
**Validation Level**: [quick | standard | thorough]
**Focus Areas**: [specific concerns, or "all"]
**Context**:
  - Changed files: [list]
  - Test files: [list]
  - Related files: [list]
```

## Output Contract

```markdown
## QA Validation Result

**Task ID**: TASK-XXX
**Status**: passed | warnings | failed
**Validation Level**: [quick | standard | thorough]
**Overall Score**: [X]/100

### Summary

[2-3 sentence overview of quality assessment]

### Category Results

| Category | Status | Score | Issues |
|----------|--------|-------|--------|
| Code-Test Alignment | ✓/⚠/✗ | X/100 | [count] |
| Integration | ✓/⚠/✗ | X/100 | [count] |
| Pattern Consistency | ✓/⚠/✗ | X/100 | [count] |
| Documentation | ✓/⚠/✗ | X/100 | [count] |
| Edge Cases | ✓/⚠/✗ | X/100 | [count] |

### Critical Issues (Must Fix)

1. **[Issue Title]**
   - Location: [file:line]
   - Problem: [description]
   - Recommendation: [fix suggestion]
   - Severity: critical

### Warnings (Should Fix)

1. **[Warning Title]**
   - Location: [file:line]
   - Problem: [description]
   - Recommendation: [fix suggestion]
   - Severity: warning

### Suggestions (Nice to Have)

1. **[Suggestion Title]**
   - Location: [file:line]
   - Recommendation: [improvement]
   - Severity: suggestion

### Missing Test Coverage

| Code Path | File:Line | Suggested Test |
|-----------|-----------|----------------|
| [path] | [location] | [test description] |

### Positive Observations

[Things done well - reinforcement for good patterns]

### Recommendations

[Prioritized list of improvements]

### Approval Status

**Ready for Commit**: Yes / No (with blockers)
**Ready for PR**: Yes / No (with blockers)
```

## Validation Levels

### Quick (2 min)

- Syntax/lint check
- Test existence verification
- Critical pattern violations only

### Standard (5 min)

- Full category analysis
- Test coverage estimation
- Pattern consistency check
- Basic edge case review

### Thorough (10 min)

- Deep code path analysis
- Comprehensive edge case enumeration
- Full integration point verification
- Documentation completeness audit
- Performance concern identification

## Scoring Rubric

### Category Scores

| Score | Meaning |
|-------|---------|
| 90-100 | Excellent - production ready |
| 75-89 | Good - minor improvements possible |
| 60-74 | Acceptable - warnings to address |
| 40-59 | Needs Work - issues to fix before commit |
| 0-39 | Failed - significant problems |

### Issue Severity

| Severity | Criteria | Action |
|----------|----------|--------|
| Critical | Bugs, security issues, data loss risk | Block commit |
| Warning | Pattern violations, missing tests | Recommend fix |
| Suggestion | Improvements, optimizations | Optional |

## Decision Matrix

| Situation | Action |
|-----------|--------|
| All categories pass | Approve for commit |
| Critical issues found | Block, list fixes |
| Warnings only | Approve with notes |
| Test coverage < 60% | Warning, suggest tests |
| Pattern violations | List, recommend fixes |
| Missing docs | Suggest additions |

## Integration with Workflow

```text
Implementation Complete
         ↓
    QA Validator ─────→ Issues Found ─────→ Return to Coder
         ↓                                         ↓
    All Passed                              Fix and Retry
         ↓
   Commit Reviewer
         ↓
      Git Commit
```

## Failure Modes

| Failure | Recovery |
|---------|----------|
| Can't read test files | Report incomplete validation |
| Pattern files missing | Use industry defaults |
| Timeout during analysis | Return partial results |
| Conflicting patterns found | Report conflict, don't block |

## Example Output

```markdown
## QA Validation Result

**Task ID**: TASK-042
**Status**: warnings
**Validation Level**: standard
**Overall Score**: 78/100

### Summary

Login implementation is solid with good test coverage. Minor pattern inconsistencies
in error handling and one missing edge case test for empty email. Ready for commit
with suggested improvements.

### Category Results

| Category | Status | Score | Issues |
|----------|--------|-------|--------|
| Code-Test Alignment | ✓ | 85/100 | 1 |
| Integration | ✓ | 90/100 | 0 |
| Pattern Consistency | ⚠ | 65/100 | 2 |
| Documentation | ✓ | 80/100 | 1 |
| Edge Cases | ⚠ | 70/100 | 2 |

### Critical Issues (Must Fix)

None

### Warnings (Should Fix)

1. **Inconsistent Error Response Format**
   - Location: src/auth/login.ts:45
   - Problem: Returns `{ error: message }` but other endpoints use `{ message, code }`
   - Recommendation: Use standardized error response from src/utils/errors.ts
   - Severity: warning

2. **Missing Empty Email Test**
   - Location: tests/auth/login.test.ts
   - Problem: No test case for empty string email
   - Recommendation: Add test: `it('rejects empty email', ...)`
   - Severity: warning

### Suggestions (Nice to Have)

1. **Add JSDoc to Login Handler**
   - Location: src/auth/login.ts:20
   - Recommendation: Document parameters, return type, and thrown errors
   - Severity: suggestion

### Missing Test Coverage

| Code Path | File:Line | Suggested Test |
|-----------|-----------|----------------|
| Empty email | login.ts:25 | Reject with validation error |
| Rate limit hit | login.ts:30 | Return 429 status |

### Positive Observations

- Good separation of concerns between validation and auth logic
- Comprehensive happy path testing
- Proper use of TypeScript types
- Clear variable naming

### Recommendations

1. Fix error response format for consistency
2. Add empty email edge case test
3. Consider adding rate limit tests

### Approval Status

**Ready for Commit**: Yes (with warnings noted)
**Ready for PR**: Yes (consider addressing warnings first)
```

## See Also

| Related | Purpose |
|---------|---------|
| [Tester](./tester.md) | Test writing and execution |
| [Commit Reviewer](./commit-reviewer.md) | Pre-commit validation |
| [Security Auditor](./security-auditor.md) | Security-focused review |
| [Code Standards](../concepts/code-standards.md) | Quality guidelines |
