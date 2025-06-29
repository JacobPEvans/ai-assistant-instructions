# Concept: Code Standards

This document outlines the universal standards for writing high-quality code.

## General Principles

- **Readability**: Write clear, self-documenting code. Prefer clarity over cleverness.
- **Naming**: Use descriptive, concise names for variables, functions, and classes.
- **DRY Principle**: Don't Repeat Yourself. Encapsulate reusable logic. See [The DRY Principle](./dry-principle.md).
- **Comments**: Use comments to explain *why* something is done, not *what* is being done.

## Security

- **No Hardcoded Secrets**: Never store secrets, API keys, or other sensitive data directly in the code. Use environment variables or a dedicated secrets management service.
- **Least Privilege**: Grant only the minimum necessary permissions for any operation.
- **Input Validation**: Validate and sanitize all external input to prevent injection attacks and other vulnerabilities.

## Error Handling

- **Robustness**: Implement comprehensive error handling.
- **Clarity**: Provide meaningful error messages that can help with debugging.
- **Logging**: Log errors with sufficient context.
