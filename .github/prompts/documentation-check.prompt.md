---
mode: 'agent'
tools: ['codebase', 'usages', 'problems', 'changes', 'terminalLastCommand', 'findTestFiles', 'githubRepo', 'editFiles', 'runCommands', 'get_syntax_docs', 'mermaid-diagram-validator', 'mermaid-diagram-preview']
description: 'Review and validate documentation consistency, completeness, and AI-friendliness'
---

Your goal is to review and validate documentation consistency, completeness, and AI-friendliness across the project.

## Documentation Review Areas

**Structure & Organization**
- Proper README.md files at appropriate levels
- Consistent directory structure documentation
- Utilize a single source of truth. Combine similar documentation across multiple files into the best location only
- Valid cross-reference links

**Content Quality**
- Clear purpose statements and setup instructions
- Working code examples with proper syntax highlighting
- Cost estimates for cloud resources
- US English, middle to high school reading level
- Professional but approachable tone

**AI-Friendly Formatting**
- Proper markdown syntax and structure
- Code blocks with language specifications
- Clear section headings and navigation
- Enforce hierarchal decimal outline numbering system (e.g. 1, 1.1, 2, 2.1, 2.1.1, 2.1.2, etc.) for all multi-level numbering
- Descriptive link text (avoid "click here")

**Cross-Reference Validation**
- Internal markdown links resolve correctly
- Link and file path references are accurate
- External URLs are accessible
- GitHub Copilot integration references are valid
- Avoid circular references

## Review Process

**Automated Checks**
```bash
# Run markdown linting
markdownlint **/*.md
# Resolve issues reported by markdownlint
# MD013 (line length) is customized to 120 characters in local workspace configs.
#   Do not break a single sentence to satisfy MD013. Either break into multiple sentences or leave as is.

# Check for broken links
markdown-link-check **/*.md

# Spell checking
cspell "**/*.md"
```

**Quality Gates**
- **Essential**: Root README.md, working setup instructions
- **Important**: Troubleshooting section, architecture overview, configuration options
- **Nice to Have**: Detailed examples, performance guides, advanced features

### Compliance Standards

**Security Documentation**
- No secrets or sensitive data exposed
- Security configuration properly documented
- Access control requirements clear
- Backup and recovery procedures documented

**Compliance**
- Appropriate license files
- Attribution for external content

## Output Format

Never output reviews to files. Output reviews directly to the user making documentation updates directly when confidence is high.

### Review Report Structure

1. **Summary**: Overall documentation health score
2. **Critical Issues**: Immediate action required
3. **Improvement Opportunities**: Enhancement suggestions
4. **Best Practices**: Compliance with standards
5. **Maintenance Recommendations**: Ongoing care suggestions

---

*Reference: [Main Instructions](../copilot-instructions.md)*
*See also: [Project Structure](../../.copilot/PROJECT.md)*
