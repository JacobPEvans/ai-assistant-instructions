# Task: Commit

Standardized git commit process for creating high-quality commits.

## Critical Rules

1. **NEVER commit without running local validation first.**
2. **Markdown files MUST pass `markdownlint-cli2` before committing.**
3. **All linters and formatters must pass locally before pushing.**
4. **Never commit directly to `main`.**

## Branching Strategy

- **Branch Naming**: Use a descriptive prefix and name, separated by a slash.
  - `test/<description>`: For Step 3 - adding tests before implementation.
  - `feat/<description>`: For new features.
  - `fix/<description>`: For bug fixes.
  - `docs/<description>`: For documentation-only changes.
  - `chore/<description>`: For maintenance tasks.
  - `refactor/<description>`: For code restructuring.

## Pre-Commit Validation (MANDATORY)

**Run these checks BEFORE staging files. Do not skip any.**

### 1. Markdown Validation (REQUIRED for all markdown changes)

```bash
# Fix auto-fixable issues first
markdownlint-cli2 --fix .

# Verify no issues remain
markdownlint-cli2 .
```

If `markdownlint-cli2` is not available, install it or use an alternative markdown linter. **Never commit markdown files that fail validation.**

### 2. Code Formatting

```bash
# Terraform
terraform fmt -recursive

# JavaScript/TypeScript
prettier --write .

# Python
black .
isort .
```

### 3. Linting

```bash
# JavaScript/TypeScript
eslint .

# Python
flake8 .
mypy .

# Terraform
terraform validate
tflint
```

### 4. Infrastructure Validation

```bash
# Terraform
terraform validate
terraform plan

# Terragrunt
terragrunt validate
terragrunt plan
```

### 5. Security Scan

Before committing, verify no sensitive data is staged:

- API keys or tokens
- Passwords or secrets
- Private keys
- `.env` files with real values

## Staging and Analysis

1. **Stage Files**: Use `git add <file>` to stage changes. Group files into logical commits.
2. **Analyze Changes**: Use `git status -v -v` to review staged changes.
3. **Review History**: Use `git log --oneline -n 5` to understand recent commit style.

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

## Pre-Push Checklist

Before running `git push`, verify:

- [ ] All local validation checks pass
- [ ] Markdown files pass `markdownlint-cli2`
- [ ] No sensitive data in staged files
- [ ] Commit messages follow Conventional Commits format
- [ ] Changes are on a feature branch (not `main`)
