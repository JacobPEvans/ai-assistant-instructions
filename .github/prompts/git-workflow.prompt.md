---
mode: 'agent'
tools: ['codebase', 'usages', 'problems', 'changes', 'terminalSelection', 'terminalLastCommand', 'fetch', 'findTestFiles', 'githubRepo', 'editFiles', 'runCommands', 'search']
description: 'Handle git version control branching, workflows, and terminal operations'
---

# Git Workflow Standards

Your goal is to handle git version control repository operations consistently according to established project standards.

This is a well-defined actionable workflow. You may make suggestions for improvements,
but the goal is to run this workflow directly in the terminal.

**Note**: Commit message generation, pull request descriptions, and code reviews are
described in other instructions files. This prompt focuses on branching, workflow
execution, and terminal operations.

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

## Quality Gates and Requirements

**Pre-Commit & Workflow Checklist:**

- ✅ **Setup**: Change to repository root using absolute path
- ✅ **Review**: Analyze all modified files for changes made
- ✅ **Organize**: Update .gitignore for files that shouldn't be committed if needed
- ✅ **Quality**: Run appropriate formatting/linting tools
- ✅ **Security**: Verify no secrets or sensitive information
- ✅ **Verify**: Analyze changes with `git status -v -v`
- ✅ **Branch**: Create appropriate branch if needed
- ✅ **Stage**: Add files to staging area
- ✅ **Commit**: Use `.copilot-commit-message-instructions.md` for consistent format
- ✅ **Push**: Push to remote repository
- ✅ **Pull Request**: Use `.copilot-pull-request-description-instructions.md` for comprehensive descriptions
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
yamllint             # For yaml/yml files
markdownlint-cli2    # For Markdown files
# Consider and recommend other formatters and linters when relevant
```

**STOP IMMEDIATELY if secrets or potentially sensitive information are detected:**

- Check for API keys, passwords, tokens
- Review environment variables and configuration files

### Step 3: Change Analysis

3.1. **Analyze all changes made**

   ```bash
   echo "=== Review changes with 'git status -v -v' ===" && \
   git status -v -v \
   echo "=== Review commit history ===" && \
   git log --oneline HEAD..origin/main

   echo "=== Review all actual changes ===" && \
   git diff -w --histogram --minimal --unified=0 --no-color
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

4.3. **Create commit**

Refer to `../.copilot-commit-message-instructions.md` for git commit instructions

### Step 5: Push and Pull Request Creation

Step 5 can be skipped if the project does not yet have fully fleshed out PROJECT.md, CONTRIBUTING.md, etc. files.

5.1 **Is this a private or public repository?**

- If **private**, this will forever be a one man show, and you shall skip ahead to step 6.
- If **public**, follow the steps below to create a pull request.

```powershell
# Check if repository is public or private
gh repo view --json visibility
```

5.2. **Push branch to remote**

```powershell
git push origin feature/<branch-name>
# For first push of new branch:
git push -u origin feature/<branch-name>
```

5.3. **Create pull request**

Refer to `../.copilot-pull-request-description-instructions.md` for git pull request description instructions

5.4. **Evaluate GitHub Copilot automated pull request review**

```powershell
gh pr view #
```

### Step 6: Merge

6.1. **Merge directly if no pull request was created**

```powershell
git checkout main && git pull origin main
git merge feature/<branch-name> --squash  # Squash merge recommended for more than 5 commits
git merge feature/<branch-name>           # Use normal merge when there are only a few commits
git push origin main
```

6.2. **Merge pull request via command line**

   ```powershell
   # Choose the best merge strategy
   gh pr merge --squash --delete-branch    # Squash merge for many commits
   gh pr merge --merge  --delete-branch    # Standard merge
   gh pr merge --rebase --delete-branch    # Rebase merge
   ```

6.3. **Clean up local environment**

```powershell
git checkout main
git pull origin main
# Delete all merged branches
git branch -d feature/<branch-name>
```
