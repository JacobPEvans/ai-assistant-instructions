# Task: Review Code

This task outlines the process for providing a thorough, constructive code review.

## Review Focus Areas

Apply [Code Standards](../concepts/code-standards.md), [Infrastructure Standards](../concepts/infrastructure-standards.md), and 
[Styleguide](../concepts/styleguide.md) when reviewing:

- **Security**: Secrets management, input validation, access control  
- **Code Quality**: Standards compliance, error handling, readability
- **Infrastructure**: Resource optimization, Terraform standards (if applicable)
- **Maintainability**: Modularity, dependencies

## Feedback Guidelines

- **Be Specific**: Point to exact lines or patterns.
- **Explain Why**: Provide a rationale for your suggestions.
- **Offer Solutions**: Suggest alternatives.
- **Use Priority Levels**:
  - **🔴 Required**: Security issues, breaking changes, major bugs.
  - **🟡 Suggested**: Code quality improvements, minor optimizations.
  - **🟢 Optional**: Style preferences, alternative approaches.

## Example Review Comment

> 🟡 **Suggested** (Code Quality):
>
> The function `process_data()` on line 72 seems to be doing multiple things.
> We should consider breaking it into smaller functions for better testability and readability.
>
> It could be split into:
>
> - `validate_data()`
> - `transform_data()`
> - `save_data()`
