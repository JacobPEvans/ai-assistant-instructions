# Claude Command: Commit

Creates standardized commits with thorough pre-planning, validation, and proper git workflow.

## Usage

```bash
/commit
/commit --no-verify
```

## External References

- [Git Standard Commits](https://github.com/standard-commits/standard-commits/blob/main/README.md)
- [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0)
- [Claude Simone Commit](https://github.com/Helmi/claude-simone/blob/master/.claude/commands/simone/commit.md)
- [Graphite.dev Git Commit Message Best Practices](https://graphite.dev/guides/git-commit-message-best-practices)
- [Keep a Living Changelog](https://keepachangelog.com/en/1.0.0/)
- [GitHub CLI Documentation](https://cli.github.com/manual/)

## Systematic 6-Step Workflow Process

### 1. Pre-Commit Validation & Security Scanning (unless --no-verify)

**Documentation Validation:**

- Attempt to resolve automatically using `markdownlint-cli2 --fix`
- `markdownlint-cli2` - Check all markdown files for formatting issues
- `markdownlint-cli2` **must** return no issues before continuing
  - Manually resolve issues that are not automatically fixed

**Infrastructure Validation:**

- `terraform validate` - Configuration syntax verification
- `terraform fmt -check` - Code formatting consistency
- `terragrunt validate` - Terragrunt configuration (if present)
- `terragrunt plan` - Execution plan verification and resource impact analysis

**Security & Quality Checks:**

- Scan for sensitive data (API keys, SSH keys, usernames, passwords, certificates)
- Resource naming convention validation
- Network configuration security review
- State file implications assessment

### 2. Repository Analysis & Argument Parsing

- Stage files logically per approved grouping
- Determine repository type (`gh repo view --json visibility`)
- Review all changes with parallel operations:
  - `git status -v -v` - View all changes in the working directory
  - `git log --oneline -3` - Recent commit context
- Parse any provided arguments (task IDs, sprint context, user instructions)
- Analyze change scope, impact, and dependencies

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

**PLANNING.md Update (Mandatory):**

- **Always update PLANNING.md** as part of every commit process
- **Move completed tasks to CHANGELOG.md**
- **Add any incomplete tasks**
- **Update entire file for proper ordering**

**CHANGELOG.md Update (Mandatory):**

- **Always update CHANGELOG.md** as part of every commit process
- **Today's Date Section**: Add changes to `YYYY-MM-DD` section first
- **Update entire file to consolidate duplicate entries**

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
3. **Add/Update Section**: Add human-readable entry under appropriate date section
4. **Format Entry**: Use bullet points starting with action verbs (e.g., "Enhanced", "Added", "Fixed")
5. **Include Context**: Reference relevant components, files, or systems affected
6. **Maintain Readability**: Write for end users, not developers - avoid technical jargon
7. **Clean Up Old Entries**: Remove oldest duplicate entries older than 1 month to keep the changelog concise
8. **Documentation Validation**: Rerun `markdownlint-cli2` and fix all issues to ensure no formatting issues after updates

**CHANGELOG.md Entry Examples:**

```markdown
## 2025-06-21
### Added
- Added <xyz> feature to <problem addressed>
- Enhanced Claude Code permissions for terraform and infrastructure operations

### Changed
- Updated <xyz> feature to <problem addressed>
- Documentation standards with plan-first methodology integration
```

### 5. Pull Request Workflow

**Commit Execution:**

- Run /compact command to shrink context
- Create commit(s)
- Handle pre-commit hook issues
- Push with upstream tracking (`git push -u origin <branch>`)

**Pull Request (PR) Workflow:**

- Avoid squash merge. Preserve complete commit history
- Include comprehensive PR description with change summary
- Resolve all PR checks (`gh pr checks`)
- Resolve all pull request comments and conversations

**PR Comment Resolution Process (MANDATORY):**

🚨 **CRITICAL REQUIREMENT**: Pull requests cannot be merged until ALL comments and conversations are resolved.

**Step-by-Step Resolution Process:**

1. **Identify All Comments**: Use `gh api repos/OWNER/REPO/pulls/PR_NUMBER/comments` to get complete list
   - For external PR comments/conversations not accessible via `gh` CLI, use GraphQL: `gh api graphql -f query='{ repository(owner: "OWNER", name: "REPO") { pullRequest(number: PR_NUMBER) { comments { nodes { body author { login } } } } } }' | jq`
2. **Review Each Comment**: Analyze every suggestion, question, and concern raised by reviewers
3. **Take Action on Each Comment**:
   - **Code Changes**: Implement requested fixes and commit changes
   - **Explanations**: Respond with detailed explanation if change not needed
   - **Clarifications**: Provide additional context or documentation as requested
4. **Respond to Comments**: Always acknowledge each comment with a response explaining what action was taken
5. **Verify Resolution**: Ensure all conversations are marked as resolved before proceeding

**Non-Negotiable Requirements:**

- ✅ **ALL comments must have responses** - No comment can be ignored
- ✅ **ALL suggestions must be addressed** - Either implemented or explained why not
- ✅ **ALL conversations must be resolved** - No open discussions remaining
- 🚫 **Never merge with unresolved comments** - This violates code review standards
- 🚫 **Never ignore reviewer feedback** - All input must be acknowledged

**Before Merge Verification:**

- Run `gh pr view PR_NUMBER --comments` to verify no unresolved comments remain
- Confirm all CI checks pass with `gh pr checks PR_NUMBER`
- Validate all conversations are marked as resolved on GitHub

### 6. User Approval & Confirmation

**Pull Request Presentation:**

- Show completed commit and pull request with grouped changes
- Highlight any security or breaking change concerns
- Present validation results and any issues resolved

**Explicit Confirmation Required:**

- Wait for user approval before proceeding
- Allow modifications to pull request if requested
- Address any user concerns or questions
- Proceed with merge (`gh pr merge --auto`)

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
- **Document in PLANNING.md**: All open TODOs and incomplete tasks
- **Maintain clear context**: Ensure all stakeholders understand impact

### Parallel Execution Optimization

- Run commands in parallel where possible

### Context Preservation

- **Cross-session continuity**: Reference previous work and decisions
- **Environment awareness**: Consider current infrastructure state
- **Task correlation**: Link commits to broader project objectives

**Security Note**: This documentation uses generic examples. Reference private infrastructure context
and organization-specific standards for real environment implementations.
