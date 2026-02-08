# Code Review Instructions

Standardized code review guidelines for AI-assisted development across Gemini Code Assist, Claude Code, and GitHub Copilot.

## Review Framework

Code reviews should systematically evaluate changes across five core dimensions. Use this framework for all AI-assisted code reviews.

### 1. Correctness

**Focus**: Logic, API usage, edge cases, and runtime behavior.

- Verify logic correctness and absence of off-by-one errors
- Check API method signatures and parameter types match documentation
- Identify unhandled edge cases and boundary conditions
- Validate type safety and null/undefined handling
- Confirm error propagation and exception handling

**Examples**: Missing null checks, incorrect loop conditions, type mismatches, unhandled error cases.

### 2. Security

**Focus**: Vulnerabilities, secrets management, and access control.

- **Secrets**: No hardcoded credentials, API keys, or sensitive data in code
- **Input Validation**: All external input sanitized and validated
- **Output Encoding**: Prevent injection attacks (SQL, XSS, command injection)
- **Access Control**: Proper authentication and authorization checks
- **Dependencies**: Vulnerable packages and outdated library versions

**Examples**: Hardcoded API keys, unsanitized SQL queries, missing authentication checks, vulnerable dependencies.

### 3. Performance & Efficiency

**Focus**: Algorithmic complexity, memory usage, and resource optimization.

- Evaluate algorithmic complexity (O(n²) loops, N+1 queries)
- Identify memory leaks and unnecessary object allocations
- Check for redundant operations and caching opportunities
- Verify lazy loading and pagination for large datasets
- Assess database query efficiency (joins, indexes, query optimization)

**Examples**: Unoptimized loops, repeated database calls, unnecessary object creation, missing pagination.

### 4. Maintainability

**Focus**: Code clarity, documentation, and future readability.

- **Naming**: Clear, descriptive names for variables, functions, and classes
- **Complexity**: Functions should be focused with single responsibility
- **Documentation**: Comments explain *why*, not *what*; docstrings for public APIs
- **DRY Principle**: No code duplication; reusable logic extracted
- **Test Coverage**: Adequate tests covering normal cases and edge cases

**Examples**: Poor naming, overly complex functions, missing documentation, duplicated logic, inadequate test coverage.

### 5. Consistency & Style

**Focus**: Adherence to project standards and conventions.

- Follow language-specific style guides (PEP 8 for Python, etc.)
- Match existing code patterns and architectural conventions
- Use consistent formatting and naming conventions
- Adhere to project linting rules (eslint, black, flake8, etc.)
- Maintain consistency with existing error handling patterns

**Examples**: Inconsistent indentation, mismatched naming conventions, violated linting rules, style deviations.

## Review Scope & Severity

### Required Changes (Block Merge)

- Security vulnerabilities or hardcoded secrets
- Logic errors or missing edge case handling
- Type safety violations or API misuse
- Test failures or missing critical tests
- Broken dependency management

### Suggested Changes (Should Address)

- Performance optimizations and efficiency improvements
- Code clarity and maintainability enhancements
- Documentation improvements
- Consistency with project standards
- Code duplication opportunities

### Optional Changes (Nice to Have)

- Style preferences that don't affect functionality
- Alternative approaches or refactoring suggestions
- Minor naming improvements
- Optimization opportunities with minimal impact

## AI Assistant-Specific Guidance

### Gemini Code Assist (`.gemini/config.yaml`)

Configure to prioritize:

- Correctness checks (logic and type safety)
- Security analysis (secrets, injection risks)
- Maintainability evaluation (naming, complexity)
- Efficiency review (algorithmic analysis)

Set `minimumSeverity` to catch all issues, then filter in reviews.

### Claude Code (`.claude/` configuration)

Use the Code Reviewer sub-agent for:

- Complex security analysis requiring context
- Infrastructure and configuration reviews
- Multi-file impact assessment
- Architectural pattern validation

### GitHub Copilot

Use inline suggestions for:

- Real-time syntax and style feedback
- Quick refactoring suggestions
- Type safety completions
- Documentation generation

## Project-Specific Rules

These rules are unique to this codebase and must be enforced during reviews:

- **Frontmatter required**: All skills, agents, and rules files must have valid YAML frontmatter with `name` and `description` fields
- **Token limits**: Files should target 500 tokens (1,000 max). Flag files that exceed this
- **Cross-references**: Within agentsmd files, reference by name only (e.g., "the github-cli-patterns skill"). Never use markdown file links
- **Portable paths**: No absolute user paths (`/Users/*`, `/home/*`, `$HOME/*`, `~/*`). Use relative paths, env vars, or PATH lookup
- **No bash `for` loops**: They break permission matching. Use parallel commands or tool-native batch operations
- **Naming conventions**: Skills use `noun-pattern`, agents use `noun-doer`
- **Log format**: Use `YYYY-MM-DD HH:mm:ss [LEVEL] {message}` (see code-standards.md)

## Review Checklist

Before merging any change:

- [ ] No hardcoded secrets or credentials
- [ ] All external input validated and sanitized
- [ ] Error handling implemented for failure paths
- [ ] Tests pass and cover normal + edge cases
- [ ] Type safety verified (no implicit any)
- [ ] Performance acceptable (no obvious O(n²) or N+1 queries)
- [ ] Code follows project style guide
- [ ] Naming is clear and descriptive
- [ ] Complex logic documented with comments
- [ ] No code duplication or DRY violations

## Related Documentation

- [Code Standards](../rules/code-standards.md) - Universal coding standards
- [Styleguide](../rules/styleguide.md) - Coding style and conventions
- [Code Reviewer Sub-Agent](../agents/code-reviewer.md) - Claude Code review details
