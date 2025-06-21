# Claude Command: Commit

Creates standardized commits with thorough pre-planning, validation, and proper git workflow.

## Usage
```bash
/commit
/commit --no-verify
```

## External References
- [Claude Simone Commit](https://github.com/Helmi/claude-simone/blob/master/.claude/commands/simone/commit.md)
- [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0)
- [Graphite.dev Git Commit Message Best Practices](https://graphite.dev/guides/git-commit-message-best-practices)
- [Keep a Living Changelog](https://keepachangelog.com/en/1.0.0/)
- [GitHub CLI Documentation](https://cli.github.com/manual/)

## Systematic 6-Step Workflow Process

### 1. Repository Analysis & Argument Parsing
- Determines repository type (`gh repo view --json visibility`)
- Reviews all changes with parallel operations:
  - `git status` - Current working tree status
  - `git diff --staged` - Staged changes analysis
  - `git diff` - Unstaged changes analysis
  - `git log --oneline -10` - Recent commit context
- Parse any provided arguments (task IDs, sprint context, user instructions)
- Analyze change scope, impact, and dependencies

### 2. Pre-Commit Validation & Security Scanning (unless --no-verify)
**Infrastructure Validation:**
  - `terraform validate` - Configuration syntax verification
  - `terraform fmt -check` - Code formatting consistency
  - `terragrunt validate` - Terragrunt configuration (if present)
  - `terragrunt plan` - Execution plan verification and resource impact analysis

**Security & Quality Checks:**
- Sensitive data scanning (API keys, passwords, certificates)
- Resource naming convention validation
- Network configuration security review
- State file implications assessment

### 3. Logical Change Grouping & Analysis
**Group changes by logical categories:**
- **Task/Feature Completion**: Related to specific work items
- **Infrastructure Changes**: New resources, services, or configurations
- **Bug Fixes**: Corrections to existing functionality
- **Configuration Updates**: Environment, provider, or settings changes
- **Documentation**: README, comments, or guide updates
- **Maintenance**: Dependency updates, formatting, refactoring

**Change Impact Analysis:**
- Identify affected resources and dependencies
- Assess breaking change potential
- Determine rollback complexity
- Evaluate security implications

### 4. Branch Strategy & Commit Proposal
**Branch Creation (mandatory):**
- **Always creates new branch** (never direct commits to main)
- Uses proper naming: `<prefix>/<description>`
- Prefixes: `feat/`, `fix/`, `hotfix/`, `chore/`, `docs/`, `refactor/`, `perf/`

**Commit Message Generation:**
- Creates context-aware conventional commit messages
- Incorporates task/argument context where provided
- Detailed explanation of infrastructure changes and reasoning
- Impact assessment and affected resource documentation

**CHANGELOG.md Update (Mandatory):**
- **Always update CHANGELOG.md** as part of every commit process
- **Calendar Versioning Format**: Use date-based versions (YY.M.DD format, e.g., 25.6.21)
- **Unreleased Section**: Add changes to `[Unreleased]` section first
- **Release Preparation**: When ready to release, move items from Unreleased to new dated version

**CHANGELOG.md Update Process:**
1. **Extract from Commit Message**: Parse commit type and description to determine changelog category
2. **Categorize Changes**: Map commit types to changelog sections:
   - `feat` → Added
   - `fix` → Fixed
   - `docs` → Changed (for documentation improvements)
   - `chore` → Changed (for maintenance/tooling)
   - `security` → Security
   - `perf` → Changed (for performance improvements)
   - `refactor` → Changed (for code restructuring)
3. **Update Unreleased Section**: Add human-readable entry under appropriate category
4. **Format Entry**: Use bullet points starting with action verbs (e.g., "Enhanced", "Added", "Fixed")
5. **Include Context**: Reference relevant components, files, or systems affected
6. **Maintain Readability**: Write for end users, not developers - avoid technical jargon

**CHANGELOG.md Entry Examples:**
```markdown
## [Unreleased]
### Added
- Comprehensive 6-step commit workflow with validation and security scanning
- Enhanced Claude Code permissions for terraform and infrastructure operations

### Changed
- Calendar versioning adoption (YY.M.DD format) for consistent release tracking
- Documentation standards with plan-first methodology integration
```

### 5. User Approval & Confirmation
**Commit Plan Presentation:**
- Show complete commit plan with grouped changes
- Display proposed commit message(s) and branch name
- Highlight any security or breaking change concerns
- Present validation results and any issues found

**Explicit Confirmation Required:**
- Wait for user approval before proceeding
- Allow modifications to commit message or grouping
- Address any user concerns or questions
- Provide alternative approaches if requested

### 6. Execution & Pull Request Management
**Commit Execution:**
- Stage files logically per approved grouping
- Create commit(s) with approved messages
- Handle pre-commit hook issues automatically
- Push with upstream tracking (`git push -u origin <branch>`)

**Pull Request Workflow:**
- **Never squash merge** - preserve complete commit history
- Include comprehensive PR description with change summary
- Proceed with PR merge if all previous steps were approved

**PR Comment Resolution Process:**
- Check for automated PR review comments (`gh pr view --comments`)
- Review all unresolved comments from copilot-pull-request-reviewer or other reviewers
- Address each comment by either:
  - Making requested code changes and committing fixes
  - Responding to comment explaining why change not needed
  - Marking comment as resolved if addressed
- Proceed with merge after all comments are resolved or accepted
- For duplicate numbering, formatting issues, or style problems: fix immediately
- For architectural suggestions: evaluate merit and implement if beneficial

## Commit Message Format
```text
type(scope): brief description

Detailed explanation of changes and reasoning.
Impact assessment and affected resources.
```

## Commit Types & Categorization

### Universal Commit Types
- `feat`: New features, infrastructure, resources, or services
- `fix`: Bug fixes, configuration corrections, issue resolution
- `chore`: Maintenance, provider updates, dependency updates, tooling
- `docs`: Documentation, guides, comments, README updates
- `refactor`: Code/resource restructuring without functionality changes
- `perf`: Performance improvements, resource optimization
- `security`: Security fixes, vulnerability patches, access control updates
- `test`: Test additions, modifications, or improvements

### Context-Aware Scoping
- **Infrastructure Projects**: `ansible`, `terraform`, `k8s`, `aws`, `azure`
- **Application Projects**: Component names, module names, feature areas
- **Documentation Projects**: Section names, guide types
- **Configuration Projects**: Environment names, service names

## Comprehensive Validation Framework

### Infrastructure Security (Terraform/Terragrunt)
- ✅ No hardcoded secrets, credentials, or sensitive data
- ✅ Proper resource naming conventions following organizational standards
- ✅ Network configuration security validation (firewalls, access control)
- ✅ State file implications and backend security review
- ✅ IAM/RBAC principle of least privilege verification
- ✅ Encryption at rest and in transit configuration

### Code Quality & Standards
- ✅ Syntax validation (`terraform validate`, language-specific linters)
- ✅ Formatting consistency (`markdownlint`, `terraform fmt`, `prettier`, language formatters)
- ✅ Plan generation without errors (`terragrunt plan`)
- ✅ Resource dependency verification and cycle detection
- ✅ Documentation completeness (variable descriptions, outputs)
- ✅ Version compatibility checking

### General Code Quality (All Projects)
- ✅ Follows existing code conventions and patterns
- ✅ Library/framework availability verification
- ✅ No introduction of security vulnerabilities
- ✅ Proper error handling and logging
- ✅ Code coverage maintenance (where applicable)

## Mandatory Guardrails & Non-Negotiables

### Workflow Integrity
- ✅ **Always create branches** with descriptive names
- ✅ **Create PRs** for tracking (except in private repos or small changes)
- ✅ **Preserve complete commit history** (no squash merging)
- ✅ **Run comprehensive validation** before any commits
- 🚫 **Never commit directly to main/master branch**
- 🚫 **Never auto-merge without proper review process**

### Quality & Security Standards
- ✅ **Detailed, context-aware commit messages** with impact analysis
- ✅ **Logical change grouping** - one logical change per commit
- ✅ **Security scanning** and sensitive data prevention
- ✅ **Backup critical state** before infrastructure changes
- ✅ **Documentation updates** concurrent with code changes

### Process Compliance
- ✅ **Explicit user approval** required before execution
- ✅ **Plan-first approach** with comprehensive pre-analysis
- ✅ **Parallel tool execution** for efficiency where possible
- ✅ **Error recovery strategies** with clear remediation steps

## Error Handling & Recovery Strategies

### Validation Failures
1. **Syntax Errors**: Fix configuration syntax, re-run validation
2. **Formatting Issues**: Apply automated formatting, verify consistency
3. **Plan Failures**: Resolve resource conflicts, dependency issues
4. **Security Violations**: Remove sensitive data, apply proper patterns

### Workflow Issues
1. **Merge Conflicts**: Provide guided manual resolution steps
2. **Pre-commit Hook Failures**: Address automatically, retry commit
3. **GitHub CLI Authentication**: Verify credentials, re-authenticate
4. **Network/Connectivity**: Implement retry logic, offline mode guidance

### State & Infrastructure Issues
1. **State Lock Conflicts**: Provide safe resolution procedures
2. **Resource Dependencies**: Analyze and resolve dependency chains
3. **Provider Authentication**: Verify and refresh provider credentials
4. **Backup & Recovery**: Ensure state backup before destructive changes

## Integration with Claude Code Best Practices

### Plan-First Methodology
- **Always plan before execution**: Break complex commits into clear steps
- **Use TodoWrite/TodoRead**: Track progress through complex commit processes
- **Document in PLANNING.md**: For major infrastructure changes
- **Maintain clear context**: Ensure all stakeholders understand impact

### Parallel Execution Optimization
- **Concurrent validation**: Run multiple validation checks simultaneously
- **Batch git operations**: Execute `git status`, `git diff`, `git log` in parallel
- **Multi-tool analysis**: Combine terraform, security, and quality checks

### Context Preservation
- **Cross-session continuity**: Reference previous work and decisions
- **Environment awareness**: Consider current infrastructure state
- **Task correlation**: Link commits to broader project objectives

**Security Note**: This documentation uses generic examples. Reference private infrastructure context and organization-specific standards for real environment implementations.
