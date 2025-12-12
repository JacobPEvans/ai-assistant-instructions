# Concept: Workspace Management

This document provides guidelines for managing a multi-repository workspace.

## Cross-Project Standards

### Documentation Requirements

Each project must maintain:

1. **README.md** at the root level with:
    - Purpose and scope statement
    - Quick start instructions
    - Usage examples
    - Cost implications (for cloud resources)
2. **Directory structure documentation** for complex projects.
3. **Change logs** for significant modifications.

### Git Workflow Standards

- **Branching**: `main` for production, `feature/*` for development, `experiment/*` for temporary tests.
- **Commits**: Follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification.
- **Command Execution**: Run git commands directly from the working directory. Do not use `git -C <path>` as it breaks permission pattern matching.

### Git Worktree Policy

**All new development work MUST be done in a separate git worktree.** This enables parallel work and clean isolation.

#### Creating a Worktree

```bash
# From the main repo directory
git worktree add ../project-name-feature -b feat/feature-name main
```

#### When to Use Worktrees

| Scenario | Worktree Required? |
|----------|-------------------|
| New feature development | Yes |
| Bug fixes requiring multiple files | Yes |
| PR review feedback implementation | Yes (use existing worktree) |
| Quick typo/config fix (1-2 lines) | No - direct on main is acceptable |
| Documentation updates | Yes, if significant changes |

#### Worktree Cleanup

Use `/git-refresh` to automatically clean up worktrees whose branches have been merged or deleted.

### Security Standards

- **Secrets**: Use `.env` files locally (never committed) and a secure parameter store (like AWS Parameter Store) for cloud resources.
- **Access**: Adhere to the principle of least privilege for all resources and services.

### Cost Management

- **Lifecycle**: Implement automated shutdown for development resources, manual cleanup for testing, and scheduled backups for production.
- **Budgets**: Define and monitor monthly budgets for different environments (Development, Testing, Production).

## Technology Integration

- **Standardization**: Use consistent versions of core technologies like Terraform, PowerShell, Python, and Node.js across projects.
- **Environment**: Set up a consistent development environment with required tools like Git, VS Code, Terraform, and relevant CLIs.

## Project Lifecycle

- **Creation**: Initialize new projects with standard templates for `README.md`, `.gitignore`, and `LICENSE`.
- **Maintenance**: Perform regular tasks like reviewing dependency updates, updating documentation, and optimizing costs.
- **Retirement**: Follow a clear process to document, archive, and clean up retired projects.
