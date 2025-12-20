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

See [Worktrees](./worktrees.md) for the authoritative worktree structure and usage guidelines.

### Branch Hygiene

See [Branch Hygiene](./branch-hygiene.md) for rules on keeping branches synchronized with main.

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
