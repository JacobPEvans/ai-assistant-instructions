# Task: Commit

Standardized git commit process for creating high-quality commits.

## Branching Strategy

Never commit directly to `main`.

- **Branch Naming**: Use a descriptive prefix and name, separated by a slash.
  - `test/<description>`: For Step 3 - adding tests before implementation.
  - `feat/<description>`: For new features.
  - `fix/<description>`: For bug fixes.
  - `docs/<description>`: For documentation-only changes.
  - `chore/<description>`: For maintenance tasks.
  - `refactor/<description>`: For code restructuring.

## Pre-Commit Validation

Before staging files, run relevant validation checks:

- **Code Formatting**: `terraform fmt`, `prettier --write .`, etc.
- **Markdown Linting**: **REQUIRED** for all markdown files: `markdownlint-cli2 .`
- **Linting**: `eslint .`, etc.
- **Infrastructure**: `terraform validate` and `terragrunt plan`.
- **Security**: Scan for sensitive data (API keys, secrets).

## Staging and Analysis

1. **Stage Files**: Use `git add <file>` to stage changes. Group files into logical commits.
2. **Analyze Changes**: Use `git status -v -v` to review staged changes and `git log --oneline -n 5` to understand recent commit history.

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

