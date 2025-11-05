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

