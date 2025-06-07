---
mode: 'agent'
tools: ['codebase', 'usages', 'problems', 'changes', 'terminalSelection', 'terminalLastCommand', 'fetch', 'findTestFiles', 'githubRepo', 'editFiles', 'runCommands', 'search', 'get_syntax_docs', 'mermaid-diagram-validator', 'mermaid-diagram-preview']
description: 'Handle git commits, pull requests, branching, and version control workflows consistently'
---

# Git Workflow Standards

Your goal is to handle all git commits, pull requests, branching, and version control workflows consistently according to established project standards.

This is a well-defined actionable workflow. You may make suggestions for improvements, but the goal is to run this workflow directly in the terminal.

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


## Complete Commit Workflow Process

### Step 1: Repository Setup and Navigation

1.1. **Change to repository root directory using absolute path**

   ```powershell
   echo "=== Attempt to change directory to repository root directory ===" && `
   cd "C:\absolute\path\to\repository" && `
   echo "=== Print current working directory ===" && `
   pwd
   ```

1.2. **Verify git repository status**

   ```powershell
   echo "=== git status ===" && `
   git status && `
   echo "=== git branch --show-current ===" && `
   git branch --show-current
   ```

### Step 2: Pre-Commit Quality Checks

2.1. **Update .gitignore if needed** for files that shouldn't be committed

   - Add patterns for temporary files, secrets, sensitive variables, build artifacts

2.2 **Run formatting and linting tools on modified files only:**

```powershell
# Format code based on project type
terraform fmt        # For Terraform files
terragrunt hclfmt    # For Terragrunt files
markdownlint         # For Markdown files
# Consider and recommend other formatters and linters when relevant
```

**STOP IMMEDIATELY if secrets or potentially sensitive information are detected:**

- Check for API keys, passwords, tokens
- Review environment variables and configuration files

### Step 3: Change Analysis

3.1. **Analyze all changes made**

   ```powershell
   echo "=== Review staged changes with 'git diff --cached' ===" && `
   git diff --cached && `
   echo "=== Review unstaged changes with 'git diff' ===" && `
   git diff --status && `
   echo "=== Review commit history ===" && `
   git log --oneline HEAD..origin/main

   echo "=== Review all actual changes ===" && `
   git diff --histogram --minimal --unified=0 --no-color
   ```

3.2. **Summarize in your own words what was changed and why**

   - Focus first on the real changes shown by the `git` commands above
     - There may be changes not mentioned in the current context
   - Use additional context and chat history to understand the reason behind those real changes
   - Understand the purpose and impact of each change
   - Document reasoning for changes for use in a commit message

### Step 4: Staging, Branch Creation, and Commit

4.1. **Stage appropriate files**

   ```powershell
   git add .  # Add all appropriate files
   # OR selectively add specific files:
   git add file1.md file2.py
   ```

4.2. **Create or update branch name**

   - Use the existing branch if it fits the changes
   - Create a new branch if the branch name does not match changes
   - Create a new branch if the current branch is `main`

   ```powershell
   git checkout -b feature/<branch-name>
   ```

4.3. **Create detailed commit message** following conventional commit format:

   ```powershell
   git commit -m "<type>: <brief description>

   <detailed explanation of what was changed and why>

   - Specific change 1
   - Specific change 2
   # - Impact or reasoning for changes

   Refs: #issue-number (if applicable)"
   ```

### Step 5: Push and Pull Request Creation

Step 5 can be skipped if the project does not yet have fully fleshed out PROJECT.md, CONTRIBUTING.md, etc. files.

5.1. **Push branch to remote**

   ```powershell
   git push origin feature/<branch-name>
   # For first push of new branch:
   git push -u origin feature/<branch-name>
   ```

5.2. **Create detailed pull request via GitHub CLI**

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

5.3. **Review PR status and checks**

   ```powershell
   gh pr status
   gh pr checks
   ```

### Step 6: Merge

6.1. **Merge directly if no pull request was created**
   ```powershell
   git checkout main && git pull origin main
   git merge feature/<branch-name> --squash  # Squash merge recommended for feature branches
   git push origin main
   ```

6.2. **Merge pull request via command line**

   ```powershell
   # Squash merge (recommended for feature branches)
   gh pr merge --squash --delete-branch

   # Alternative merge methods:
   gh pr merge --merge --delete-branch     # Standard merge
   gh pr merge --rebase --delete-branch    # Rebase merge
   ```

6.3. **Clean up local environment**

   ```powershell
   git checkout main
   git pull origin main
   git branch -d feature/<branch-name>  # Delete local branch
   ```
