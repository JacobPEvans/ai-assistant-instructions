# Task: Generate Code

This task outlines the standards for generating high-quality, maintainable, and secure code.

## 1. Understand the Goal & Existing Code

-   Clarify the user's requirements if they are ambiguous.
-   Analyze the surrounding files to understand the existing style, conventions, and architectural patterns. Prefer existing libraries and frameworks.

## 2. General Principles

-   **Code Quality**:
    -   Follow language-specific conventions and formatting rules.
    -   Use descriptive, concise naming for variables, functions, and classes.
    -   Prefer readable code over clever implementations.
-   **Documentation**:
    -   Write self-documenting code with clear variable/function names.
    -   Include comments to explain *why*, not *what*.
    -   Document cost implications for cloud resources.
-   **Security**:
    -   Never hardcode secrets. Use environment variables or a secret management service.
    -   Apply the principle of least privilege for all permissions.
    -   Include input validation for all user-facing interfaces.

## 3. Technology-Specific Guidelines

-   **Terraform/Terragrunt**:
    -   Use variables instead of hardcoded values.
    -   Configure remote state with locking.
    -   Follow module structure and naming conventions.
-   **Python**:
    -   Follow PEP 8 style guidelines.
    -   Use type hints and docstrings.
    -   Use virtual environments and pin dependencies in `requirements.txt`.

## 4. Error Handling and Logging

-   Handle expected errors gracefully with user-friendly messages.
-   Log errors with sufficient context for debugging.
-   Use structured logging where possible.

## 5. Testing and Validation

-   Include unit tests for core functionality.
-   Run formatters and linters before committing.
-   Verify documentation accuracy.