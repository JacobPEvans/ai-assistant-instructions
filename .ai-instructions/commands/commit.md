# Task: Commit

This task outlines the complete, systematic workflow for creating high-quality, standardized git commits.

## Context in 5-Step Workflow

This commit process is used in multiple steps of the core workflow:

- **Step 3:** A single `test` commit is created containing only the new, failing tests. This commit is used to create the initial pull request for review.
- **Step 4:** One or more `feat`, `fix`, or `refactor` commits are created as you implement the code to make the tests pass.
  These are pushed to the existing pull request branch.

## Workflow Overview

This diagram shows how commits are made within the new 5-step process.

```mermaid
graph TD
    A[Start] --> B[Step 3: Define Success];
    B --> C[git checkout -b test/add-new-feature];
    C --> D[Write Failing Tests];
    D --> E[git add tests/];
    E --> F[git commit -m "test(scope): add tests for new feature"];
    F --> G[Create Pull Request];

    G --> H[Step 4: Implement];
    H --> I[Write Code to Pass Tests];
    I --> J[Pre-Commit Validation];
    J --> K[git add src/];
    K --> L[git commit -m "feat(scope): implement new feature"];
    L --> M[git push];

    M --> N[Step 5: Finalize];
    N --> O[End];
```

## Branching Strategy

Before committing, ensure you are on the correct branch. Never commit directly to `main`.

- **Branch Naming**: Use a descriptive prefix and name, separated by a slash.
  - `test/<description>`: **Use this for Step 3.** For adding or modifying tests before implementation.
  - `feat/<description>`: For new features.
  - `fix/<description>`: For bug fixes.
  - `docs/<description>`: For documentation-only changes.
  - `chore/<description>`: For maintenance tasks.
  - `refactor/<description>`: For code restructuring.
- **Example**: `git checkout -b test/add-user-authentication`

## Pre-Commit Validation

Before staging files, run all relevant validation checks.

- **Code Formatting**: `terraform fmt`, `prettier --write .`, etc.
- **Linting**: `markdownlint-cli2 .`, `eslint .`, etc.
- **Infrastructure**: `terraform validate` and `terragrunt plan`.
- **Security**: Scan for sensitive data (API keys, secrets).

## Staging and Analysis

1. **Stage Files**: Use `git add <file>` to stage changes. Group files into logical commits.
2. **Analyze Changes**:
    - `git status -v -v`: Review all staged and unstaged changes.
    - `git log --oneline -n 5`: Understand recent commit history.

## Commit Message Format

All commit messages must follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.

### Structure

```text
<type>(<scope>): <subject>

<body>

<footer>
```

- **Type**: `test`, `feat`, `fix`, `docs`, `style`, `refactor`, `chore`.
- **Scope** (optional): The part of the codebase affected (e.g., `auth`, `db`, `ui`).
- **Subject**: A concise description of the change, in lowercase, under 72 characters.
- **Body** (optional): A more detailed explanation of the "why" behind the changes.
- **Footer** (optional): Reference related issues (e.g., `Fixes #123`).

### Examples

**Simple Commit:**

```bash
feat(auth): implement passwordless login via email links
```

**Complex Commit:**

```bash
fix(api): resolve intermittent 502 errors on user-service

The user-service was experiencing connection timeouts to the Redis cache
during periods of high load. This was caused by an insufficient connection
pool size.

- Increased the Redis connection pool from 10 to 50.
- Added exponential backoff for connection retries.
- Improved logging to capture connection pool metrics.

Refs: #456
```

## Finalizing the Commit

After crafting the message, commit the changes using `git commit`. Then, push the changes to the remote branch for the pull request using `git push`.
