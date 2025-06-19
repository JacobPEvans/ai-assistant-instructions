# Claude Command: Commit

Creates standardized commits with terraform-specific validation and proper git workflow.

## Usage
```
/commit
/commit --no-verify
```

## Workflow Process

### 1. Repository Analysis
- Determines repository type (`gh repo view --json visibility`)
- Reviews all changes with `git status` and `git diff`
- Analyzes change scope and impact

### 2. Pre-Commit Validation (unless --no-verify)
- `terraform validate` - Configuration syntax
- `terraform fmt -check` - Code formatting  
- `terragrunt validate` - Terragrunt configuration (if present)
- `terragrunt plan` - Execution plan verification
- Sensitive data scanning

### 3. Branch & Commit Creation
- **Always creates new branch** (never direct commits to main)
- Uses proper naming: `<prefix>/<description>`
- Prefixes: `feat/`, `fix/`, `hotfix/`, `chore/`, `docs/`
- Creates conventional commit with detailed analysis
- Pushes with upstream tracking

### 4. Pull Request Management
- **Always creates PR** for tracking
- Private repos: Can merge immediately
- Public repos: Must wait for approval
- **Never squash merge** - preserves commit history

## Commit Message Format
```
type(scope): brief description

Detailed explanation of infrastructure changes and reasoning.
Impact assessment and affected resources.

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>
```

## Terraform-Specific Commit Types
- `feat`: New infrastructure, resources, services
- `fix`: Bug fixes, configuration corrections
- `chore`: Provider updates, maintenance, tooling
- `docs`: Documentation, guides, comments
- `refactor`: Resource restructuring without functionality changes
- `perf`: Resource optimization, performance improvements

## Validation Requirements
### Infrastructure Security
- No hardcoded secrets or sensitive data
- Proper resource naming conventions
- Network configuration validation
- State file implications review

### Code Quality
- Terraform syntax validation
- Formatting consistency (`terraform fmt`)
- Plan generation without errors
- Resource dependency verification

## Mandatory Guardrails
- ✅ Never commit directly to main branch
- ✅ Always create PRs (even private repos)
- ✅ Never auto-merge without approval
- ✅ Preserve full commit history (no squashing)
- ✅ Run validation before commits
- ✅ Detailed commit messages with context

## Error Handling
- Fix validation issues before retry
- Resolve conflicts manually with guidance
- Address sensitive data exposure
- Check GitHub CLI authentication if PR creation fails

**Note**: Reference private infrastructure context for real environment details. This file uses placeholder values for public repository safety.