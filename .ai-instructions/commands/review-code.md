---
description: Process for providing thorough, constructive code reviews
allowed-tools: Read, Grep, Glob
author: JacobPEvans
---

# Task: Review Code

Process for providing thorough, constructive code reviews.

## Review Focus Areas

Apply [Code Standards](../concepts/code-standards.md), [Infrastructure Standards](../concepts/infrastructure-standards.md), and [Styleguide](../concepts/styleguide.md):

- **Security**: Secrets management, input validation, access control
- **Code Quality**: Standards compliance, error handling, readability
- **Infrastructure**: Resource optimization, Terraform standards
- **Maintainability**: Modularity, dependencies

## Feedback Guidelines

- **Be Specific**: Point to exact lines or patterns
- **Explain Why**: Provide rationale for suggestions
- **Offer Solutions**: Suggest alternatives

## Priority Levels

- **🔴 Required**: Security issues, breaking changes, major bugs
- **🟡 Suggested**: Code quality improvements, minor optimizations
- **🟢 Optional**: Style preferences, alternative approaches

## Example

> 🟡 **Suggested** (Code Quality): The function `process_data()` on line 72 is doing multiple things.
> Consider splitting into `validate_data()`, `transform_data()`, and `save_data()` for better testability.
