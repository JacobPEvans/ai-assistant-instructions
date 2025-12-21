# Concept: Code Standards

This document outlines the universal standards for writing high-quality code.

## Before You Start

Before writing any code, ensure you:

- **Clarify ambiguous requirements**: Ask questions when specifications are unclear
- **Analyze existing code patterns and conventions**: Study the codebase to match existing style
- **Prefer existing libraries and frameworks**: Avoid reinventing the wheel

## General Principles

- **Readability**: Write clear, self-documenting code. Prefer clarity over cleverness.
- **Naming**: Use descriptive, concise names for variables, functions, and classes.
- **DRY Principle**: Don't Repeat Yourself. Encapsulate reusable logic. See [The DRY Principle](./dry-principle.md).
- **Comments**: Use comments to explain *why* something is done, not *what* is being done.
- **Security**: Write code that is secure by default. Follow best practices for input validation, output encoding, and dependency management.
- **Test-Driven Development (TDD)**: Development must follow the TDD methodology. Write failing tests before writing implementation code.
- **Simplicity**: Keep code simple and easy to understand. Avoid unnecessary complexity.

## Security

- **No Hardcoded Secrets**: Never store secrets, API keys, or other sensitive data directly in the code.
  Use environment variables or a dedicated secrets management service.
- **Least Privilege**: Grant only the minimum necessary permissions for any operation.
- **Input Validation**: Validate and sanitize all external input to prevent injection attacks and other vulnerabilities.

## Error Handling

- **Robustness**: Implement comprehensive error handling.
- **Clarity**: Provide meaningful error messages that can help with debugging.
- **Logging**: Log errors with sufficient context.

## Technology-Specific Guidelines

### Python

- **Follow PEP 8**: Adhere to Python's official style guide
- **Use type hints**: Add type annotations for function parameters and return values
- **Write docstrings**: Document all functions, classes, and modules using docstrings
- **Virtual environments**: Always use virtual environments for dependency isolation
- **Pin dependencies appropriately**: For deployed applications, use a fully pinned requirements/lock file.
  For libraries, specify compatible version ranges in pyproject.toml instead of pinning exact versions.
- **Run formatters and linters**: Use tools like `black`, `flake8`, and `mypy` before committing

### Bash / Shell

- **NEVER use `for` loops**: For loops break permission matching and force sequential execution. This is a hard ban.
  - Instead: Run multiple simple commands in parallel
  - Instead: Use tool-native batch operations (e.g., `git add file1 file2 file3`)
  - Instead: Use find with -exec (when appropriate)
- **No `git -C <path>`**: This breaks permission patterns. Run git commands from the correct directory.
- **Prefer parallel execution**: Multiple independent commands should run in parallel, not chained with `&&`
