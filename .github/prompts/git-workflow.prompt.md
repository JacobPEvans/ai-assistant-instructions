---
mode: 'agent'
tools: ['codebase', 'changes', 'terminalSelection', 'terminalLastCommand', 'githubRepo', 'runCommands', 'search']
description: 'Handle git commits, pull requests, branching, and version control workflows consistently'
---

Your goal is to handle all git commits, pull requests, branching, and version control workflows consistently according to established project standards.

## Git Workflow Standards

**Branch Management**
- **main**: Production-ready code only - never commit directly
- **feature/[description]**: Feature development with descriptive names
- **experiment/[topic]**: Learning and testing (delete after completion)

**Commit Standards**
Use conventional branch and commit prefixes:
- `feat:` - New features or functionality
- `fix:` - Bug fixes and corrections  
- `docs:` - Documentation changes only
- `refactor:` - Code restructuring without functional changes
- `test:` - Test additions or modifications
- `chore:` - Maintenance tasks, dependency updates

**Pre-Commit Requirements**
- Change directory to the relevant git repository root
- Run formatting/linting: `terraform fmt`, `terragrunt hclfmt`, `markdownlint` when relevant
- Never commit secrets or sensitive information
- Use `git mv` for file operations to maintain history
- Commit after modifying 5+ files or 100+ lines of code

**Pull Request Process**
- Create descriptive PR titles and descriptions
- Reference related issues or tickets
- Include testing instructions and cost impact
- Clean up merged branches after successful merges

## Common Workflows

**Feature Development**
```bash
# Create branch or update name of current branch if needed
git checkout -b feature/add-monitoring
# Make changes
git add .
git commit -m "feat: add Grafana monitoring dashboard"
git push origin feature/add-monitoring
# Create PR via GitHub CLI
```