# Task: Review Code

This task outlines the process for providing a thorough, constructive code review, focusing on security, maintainability, and adherence to project standards.

## Review Focus Areas

-   **Security**:
    -   **Secrets Management**: No hardcoded credentials, API keys, or sensitive data.
    -   **Input Validation**: Proper sanitization and validation of user inputs.
    -   **Access Control**: The principle of least privilege is applied to all permissions.
-   **Code Quality**:
    -   **Standards Compliance**: Follows established coding conventions and formatting.
    -   **Error Handling**: Comprehensive error handling with meaningful messages.
    -   **Readability**: The code is clear, self-documenting, and easy to understand.
-   **Infrastructure & Cost** (if applicable):
    -   **Resource Optimization**: Cloud resources are right-sized and cost-effective.
    -   **Terraform Standards**: Follows module structure and naming conventions.
-   **Maintainability**:
    -   **Modularity**: Functions and modules have single responsibilities.
    -   **Dependencies**: Minimal and well-justified external dependencies.

## Feedback Guidelines

-   **Be Specific**: Point to exact lines or patterns.
-   **Explain Why**: Provide a rationale for your suggestions.
-   **Offer Solutions**: Suggest alternatives.
-   **Use Priority Levels**:
    -   **🔴 Required**: Security issues, breaking changes, major bugs.
    -   **🟡 Suggested**: Code quality improvements, minor optimizations.
    -   **🟢 Optional**: Style preferences, alternative approaches.

## Example Review Comment

> 🟡 **Suggested** (Code Quality):
>
> The function `process_data()` on line 72 seems to be doing multiple things. We should consider breaking it into smaller functions for better testability and readability.
>
> It could be split into:
>
> -   `validate_data()`
> -   `transform_data()`
> -   `save_data()`
