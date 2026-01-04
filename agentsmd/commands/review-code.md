---
description: Process for providing thorough, constructive code reviews
model: sonnet
author: JacobPEvans
allowed-tools: Task, TaskOutput, Read, Grep, Glob, TodoWrite
---

# Task: Review Code

Process for providing thorough, constructive code reviews.

## Review Focus Areas

Apply the code-standards, infrastructure-standards, and styleguide rules:

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
