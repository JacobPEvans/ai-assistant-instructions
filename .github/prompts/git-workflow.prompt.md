---
mode: 'agent'
tools: ['codebase', 'usages', 'problems', 'changes', 'terminalSelection', 'terminalLastCommand', 'fetch', 'findTestFiles', 'githubRepo', 'editFiles', 'runCommands', 'search', 'get_syntax_docs', 'mermaid-diagram-validator', 'mermaid-diagram-preview']
description: 'Handle git commits, pull requests, branching, and version control workflows consistently'
---

# Git Workflow Standards

Your goal is to handle all git commits, pull requests, branching, and version control workflows consistently according to established project standards.

This is a well-defined actionable workflow. You may make suggestions for improvements, but the goal is to run this workflow directly in the terminal.

## Complete Commit Workflow Process

### Step 1: Repository Setup and Navigation

1. **Change to repository root directory using absolute path**

   ```powershell
   cd "C:\absolute\path\to\repository"
   pwd  # Verify correct location
   ```

2. **Verify git repository status**

   ```powershell
   git status
   git branch --show-current
   ```

3. **Create or update branch name**

   ```powershell
   git checkout -b feature/branch-name
   ```

### Step 2: File Management and Staging

1. **Review all modified files**

   ```powershell
   git status --porcelain
   git diff --name-only
   ```

2. **Update .gitignore if needed** for files that shouldn't be committed

   - Add patterns for temporary files, secrets, sensitive variables, build artifacts

3. **Stage appropriate files**

   ```powershell
   git add .  # Add all appropriate files
   # OR selectively add specific files:
   git add file1.md file2.py
   ```

### Step 3: Pre-Commit Quality Checks

**Run formatting and linting tools on modified files only:**

```powershell
# Format code based on project type
terraform fmt        # For Terraform files
terragrunt hclfmt    # For Terragrunt files
markdownlint         # For Markdown files
# Consider and recommend other formatters and linters when relevant
```

**Verify no secrets or sensitive information:**

- Check for API keys, passwords, tokens
- Review environment variables and configuration files

### Step 4: Change Analysis and Commit Message Creation

1. **Analyze every change made on the branch**

   ```powershell
   git diff --cached                    # Review staged changes
   git diff --stat                      # Summary of changes
   git log --oneline main..HEAD         # Commits on current branch
   ```

2. **Create and commit with in-depth message** following conventional commit format:

   ```powershell
   # Structure:
   # <type>: <brief description>
   #
   # <detailed explanation of what was changed and why>
   #
   # - Specific change 1
   # - Specific change 2
   # - Impact or reasoning for changes
   #
   # Refs: #issue-number (if applicable)

   git commit -m "feat: add comprehensive git workflow documentation

   Enhanced git workflow prompt to include complete step-by-step process
   for repository management, file staging, quality checks, and PR creation.

   - Added absolute path navigation requirements
   - Included comprehensive change analysis steps
   - Expanded commit message guidelines with examples
   - Added complete PR creation and merge workflow

   This ensures consistent git workflows across all projects and AI agents."
   ```

### Step 5: Push and Pull Request Creation

1. **Push branch to remote**

   ```powershell
   git push origin feature/branch-name
   # For first push of new branch:
   git push -u origin feature/branch-name
   ```

2. **Create detailed pull request via GitHub CLI**

   ```powershell
   gh pr create --title "feat: descriptive PR title" \
     --body "## Description

   Detailed explanation of changes and their purpose.

   ## Changes Made
   - Specific change 1
   - Specific change 2

   ## Testing Instructions
   1. Step-by-step testing process
   2. Expected outcomes   ## Cost Impact
   - Estimated monthly cost: $X
   - Cost justification if >$5/month

   ## Related Issues
   - Fixes #issue-number
   - Addresses #issue-number"
   ```

### Step 6: Pull Request Management and Merge

1. **Review PR status and checks**

   ```powershell
   gh pr status
   gh pr checks
   ```

2. **Merge pull request via command line**

   ```powershell
   # Squash merge (recommended for feature branches)
   gh pr merge --squash --delete-branch

   # Alternative merge methods:
   gh pr merge --merge --delete-branch     # Standard merge
   gh pr merge --rebase --delete-branch    # Rebase merge
   ```

3. **Clean up local environment**

   ```powershell
   git checkout main
   git pull origin main
   git branch -d feature/branch-name  # Delete local branch
   ```

## Branch Management Standards

### Branch Types

- **main**: Production-ready code only - never commit directly
- **feature/[description]**: Feature development with descriptive names
- **experiment/[topic]**: Learning and testing (delete after completion)
- **fix/[description]**: Bug fixes and corrections
- **docs/[description]**: Documentation-only changes

### Branch Naming Conventions

- Use lowercase with hyphens: `feature/add-monitoring-dashboard`
- Include brief description: `fix/correct-terraform-syntax`
- Avoid generic names: NOT `feature/updates` or `fix/bugs`

## Commit Message Standards

**Conventional Commit Prefixes:**

- `feat:` - New features or functionality
- `fix:` - Bug fixes and corrections
- `docs:` - Documentation changes only
- `refactor:` - Code restructuring without functional changes
- `test:` - Test additions or modifications
- `chore:` - Maintenance tasks, dependency updates

## Quality Gates and Requirements

**Pre-Commit & PR Checklist:**

- ✅ **Setup**: Change to repository root using absolute path
- ✅ **Review**: Analyze all modified files for changes made
- ✅ **Organize**: Update .gitignore for files that shouldn't be committed if needed
- ✅ **Quality**: Run appropriate formatting/linting tools
- ✅ **Security**: Verify no secrets or sensitive information
- ✅ **Verify**: Analyze changes with `git diff --cached` and `git diff --stat`
- ✅ **Document**: Create detailed commit and PR descriptions with:
  - Conventional prefix (feat/fix/docs/etc.)
  - Specific changes and their purpose
  - Testing instructions
  - Cost impact if applicable (especially if >$5/month)
  - Related issue references
- ✅ **Validate**: Ensure all CI/CD checks are passing before merge

## Automation and Integration

**GitHub CLI Integration:**

- Use `gh` commands for PR creation and management
- Leverage `gh pr checks` to verify CI/CD status
- Automate branch cleanup with `--delete-branch` flag
