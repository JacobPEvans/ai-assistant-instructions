# Concept: Styleguide

This document serves as the comprehensive coding styleguide for AI-assisted development, specifically designed for code review tools like Gemini Code Assist.

## Introduction

This styleguide consolidates all coding standards, best practices, and conventions for this project. It is designed to be consumed by AI code review systems to ensure consistent, high-quality code reviews.

## Key Principles

1. **[Idempotency](./idempotency.md)**: All operations must be repeatable with consistent results.
2. **AI-First Development**: All code and documentation optimized for AI consumption.
3. **Security by Default**: Follow defensive security practices in all code.
4. **[DRY Principle](./dry-principle.md)**: Eliminate duplication across code and documentation.
5. **Systematic Workflows**: Use the [5-step development workflow](../workflows/1-research-and-explore.md).

## Code Standards

For comprehensive code quality guidelines, see [Code Standards](./code-standards.md), which covers:

- Readability and naming conventions
- Security best practices
- Error handling requirements
- Test-driven development methodology

## Documentation Standards

For documentation formatting and structure requirements, see [Documentation Standards](./documentation-standards.md), which covers:

- Markdown formatting conventions
- Hierarchical numbering for AI tracking
- Linking strategies and DRY compliance
- Conciseness requirements

## Infrastructure Standards

For Infrastructure as Code guidelines, see [Infrastructure Standards](./infrastructure-standards.md), which covers:

- Idempotency requirements
- Security and least privilege principles
- Cost management practices

## Language-Specific Conventions

### JavaScript/TypeScript
- Use TypeScript for all new JavaScript code
- Prefer `const` over `let`, avoid `var`
- Use descriptive function and variable names
- Implement proper error boundaries in React components

### Python
- Follow PEP 8 style guidelines
- Use type hints for all function signatures
- Prefer list comprehensions over loops where readable

### Markdown
- Maximum line length: 160 characters (MD013 rule)
- Use hierarchical numbering (1., 1.1., 1.1.1.) for structured content
- Reference other documents instead of duplicating content

## AI Tools Integration

### GitHub Copilot
- Configuration in `.github/copilot-instructions.md`
- Used for real-time, in-editor assistance

### Claude Code
- Configuration in `.claude/` directory
- Used for complex, multi-step workflows

### Gemini Code Assist
- Configuration in `.gemini/` directory
- Used for code reviews and pull request analysis

## Code Review Expectations

When reviewing code, focus on:

1. **Security vulnerabilities** and hardcoded secrets
2. **Performance implications** of algorithmic choices
3. **Maintainability** and code clarity
4. **Test coverage** and TDD compliance
5. **Documentation accuracy** and completeness
6. **DRY principle violations** and code duplication
7. **Standards compliance** per the referenced documents above

## Examples of Preferred Code Structure

### Function Documentation
```typescript
/**
 * Calculates the compound interest for an investment.
 * @param principal - Initial investment amount
 * @param rate - Annual interest rate (as decimal, e.g., 0.05 for 5%)
 * @param time - Investment period in years
 * @returns The final amount after compound interest
 */
function calculateCompoundInterest(principal: number, rate: number, time: number): number {
  return principal * Math.pow(1 + rate, time);
}
```

### Error Handling
```typescript
async function fetchUserData(userId: string): Promise<User | null> {
  try {
    const response = await api.get(`/users/${userId}`);
    return response.data;
  } catch (error) {
    logger.error('Failed to fetch user data', { userId, error: error.message });
    return null;
  }
}
```

### Security Best Practices

See [Code Standards](./code-standards.md) for comprehensive security requirements including secrets management and input validation.
