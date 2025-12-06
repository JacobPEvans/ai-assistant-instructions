---
title: "Review PR"
description: "Conduct comprehensive PR reviews with systematic analysis, quality checks, and constructive feedback"
type: "command"
version: "1.0.0"
allowed-tools: "*"
think: true
author: "roksechs"
source: "https://gist.github.com/roksechs/3f24797d4b4e7519e18b7835c6d8a2d3"
---

## PR Review Conductor

> **Attribution**: This command is from [roksechs](https://gist.github.com/roksechs/3f24797d4b4e7519e18b7835c6d8a2d3)
> Part of the development lifecycle: `/rok-shape-issues` -> `/rok-resolve-issues` -> `/rok-review-pr` -> `/rok-respond-to-reviews`

Comprehensive and systematic Pull Request review system focusing on code quality, architectural consistency, and constructive feedback delivery.

### Core Capabilities

**Phase 1: PR Analysis & Context Understanding** (pr_analysis)

- **Change scope assessment**: Analyze diff size, affected files, and complexity
- **Issue linkage verification**: Confirm PR addresses linked issues completely
- **Dependency mapping**: Identify potential conflicts with other PRs/branches
- **Risk evaluation**: Assess breaking changes and backward compatibility

**Phase 2: Comprehensive Quality Assurance** (quality_assurance)

- **Automated checks**: TypeScript, linting, testing, build verification
- **Code standards**: Style consistency, naming conventions, architectural patterns
- **Security assessment**: Vulnerability scanning, authentication, data handling
- **Performance impact**: Bundle size, runtime performance, memory usage

**Phase 3: In-depth Code Review** (code_review)

- **Logic verification**: Algorithm correctness, edge case handling
- **Architecture compliance**: Design patterns, dependency injection, separation of concerns
- **Documentation review**: Code comments, README updates, API documentation
- **Test coverage**: Unit tests, integration tests, edge case coverage

**Phase 4: Constructive Feedback Delivery** (feedback_delivery)

- **Structured comments**: Clear, actionable, prioritized feedback
- **Positive reinforcement**: Acknowledge good practices and improvements
- **Educational guidance**: Explain reasoning behind suggestions
- **Decision recording**: Document approval/request changes with rationale

### GitHub CLI Mastery

> **Command Patterns:**

#### PR Information Gathering

```bash
# Get comprehensive PR details
gh pr view {PR_NUMBER} --json title,body,commits,files,reviews,labels

# Analyze changed files and diff
gh pr diff {PR_NUMBER}
gh pr view {PR_NUMBER} --json files | jq '.files[].filename'

# Check CI/CD status and checks
gh pr checks {PR_NUMBER}
gh pr view {PR_NUMBER} --json statusCheckRollup
```

#### Quality Verification

```bash
# Checkout PR for local testing
gh pr checkout {PR_NUMBER}

# Run comprehensive quality checks
bun run typecheck
bun run test:run
bun run build
bun run lint

# Check for security vulnerabilities
npm audit --audit-level moderate
```

#### Review Submission

```bash
# Submit review with comments
gh pr review {PR_NUMBER} --approve --body "Comprehensive review summary"
gh pr review {PR_NUMBER} --request-changes --body "Changes needed before approval"

# Add specific line comments
gh api repos/:owner/:repo/pulls/{PR_NUMBER}/comments \
  -f body="Specific feedback" \
  -F commit_id="{COMMIT_SHA}" \
  -F path="file/path.ts" \
  -F line=42
```

### Systematic Review Workflow

> **Workflow Steps:**

#### Step 1: Context Analysis

```bash
# Gather PR context and scope
gh pr view {PR_NUMBER} --json title,body,commits,files,reviews
gh issue list --search "is:open mentioned:{PR_NUMBER}"
```

#### Step 2: Local Quality Verification

```bash
# Checkout and test locally
gh pr checkout {PR_NUMBER}

# Execute full quality pipeline
bun run typecheck
bun run test:run
bun run build
bun run lint
```

#### Step 3: Structured Code Review

- **Architecture patterns**: Verify clean architecture compliance
- **Code quality**: Check readability, maintainability, performance
- **Test quality**: Ensure comprehensive coverage and meaningful tests
- **Documentation**: Review inline comments and external documentation

#### Step 4: Feedback Documentation & Submission

- **Categorize feedback**: Critical -> Major -> Minor -> Enhancement
- **Provide examples**: Show better approaches where applicable
- **Record decision**: Submit formal review with clear rationale
- **MANDATORY**: Record all feedback on GitHub for team visibility

### Review Excellence Standards

> **Best Practices:**

#### Constructive Communication

- **Specific feedback**: Point to exact lines and provide concrete suggestions
- **Educational approach**: Explain "why" behind recommendations
- **Balanced perspective**: Highlight both strengths and improvement areas
- **Respectful tone**: Maintain professional and supportive communication

#### Technical Rigor

- **Comprehensive testing**: Verify functionality across different scenarios
- **Performance awareness**: Consider impact on application performance
- **Security mindset**: Identify potential security vulnerabilities
- **Maintainability focus**: Assess long-term code maintainability

#### Process Efficiency

- **Timely reviews**: Provide feedback within reasonable timeframes
- **Actionable comments**: Ensure all feedback is specific and implementable
- **Follow-up tracking**: Monitor resolution of requested changes
- **Knowledge sharing**: Use reviews as learning opportunities for the team

### Review Categories & Criteria

> **Review Criteria:**

#### Critical Issues (Block Merge)

- Security vulnerabilities or data exposure risks
- Breaking changes without proper migration strategy
- Failed automated tests or build processes
- Significant performance regressions

#### Major Issues (Request Changes)

- Architectural pattern violations
- Missing or inadequate test coverage
- Poor error handling or edge case coverage
- Incomplete documentation for public APIs

#### Minor Issues (Suggest Improvements)

- Code style inconsistencies
- Optimization opportunities
- Better naming conventions
- Enhanced code comments

#### Enhancements (Optional)

- Performance optimizations
- Code structure improvements
- Additional test scenarios
- Documentation enhancements

### Usage Instructions

> **Usage:**
>
> **Command Execution**: `/rok-review-pr`
>
> **Example Prompts**:
>
> - "Review PR #15 comprehensively including code quality, tests, and documentation"
> - "Conduct systematic review of the current PR with focus on architecture compliance"
> - "Perform detailed code review and provide constructive feedback with examples"
> - "Analyze PR changes for security, performance, and maintainability concerns"

**Workflow Integration**:

- **Strategic context**: `/rok-shape-issues` establishes appetite-driven Issue shaping and problem definition
- **Implementation context**: `/rok-resolve-issues` provides Issue resolution and PR creation background
- **Post-review**: Guide authors to use `/rok-respond-to-reviews` for efficient feedback resolution

**Complete Development Lifecycle**: `/rok-shape-issues` -> `/rok-resolve-issues` -> `/rok-review-pr` -> `/rok-respond-to-reviews`

This command ensures thorough, constructive, and educationally valuable PR reviews that strengthen both code quality and team knowledge.
