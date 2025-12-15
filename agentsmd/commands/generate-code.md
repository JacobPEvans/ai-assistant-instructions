---
description: Standards for generating high-quality, maintainable, and secure code
model: opus
allowed-tools: "*"
author: JacobPEvans
---

# Task: Generate Code

Standards for generating high-quality, maintainable, and secure code.

## Before You Start

- Clarify ambiguous requirements
- Analyze existing code patterns and conventions
- Prefer existing libraries and frameworks

## General Principles

Follow [Code Standards](../concepts/code-standards.md) for code quality, security, and documentation requirements.

## Technology-Specific Guidelines

- **Terraform/Terragrunt**:
  - Use variables instead of hardcoded values.
  - Configure remote state with locking.
- **Python**:
  - Follow PEP 8 style guidelines.
  - Use type hints and docstrings.
  - Use virtual environments and pin dependencies in `requirements.txt`.

## Error Handling and Testing

- Handle errors gracefully with user-friendly messages
- Include unit tests for core functionality
- Run formatters and linters before committing
