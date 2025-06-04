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
- Working cross-reference links
- Required files: LICENSE, .gitignore, CHANGELOG (if applicable)

**Content Quality**
- Clear purpose statements and setup instructions
- Working code examples with proper syntax highlighting
- Cost estimates for cloud resources
- US English, middle/high school reading level
- Professional but approachable tone

**AI-Friendly Formatting**
- Proper markdown syntax and structure
- Code blocks with language specifications
- Clear section headings and navigation
- Descriptive link text (avoid "click here")
- Line length under 120 characters

**Cross-Reference Validation**
- Internal markdown links work correctly
- File path references are accurate
- External URLs are accessible
- GitHub Copilot integration references

## Review Process

**Automated Checks**
```bash
# Run markdown linting
markdownlint **/*.md

# Check for broken links
markdown-link-check **/*.md

# Spell checking
cspell "**/*.md"
```

**Quality Gates**
- **Essential**: Root README.md, working setup instructions, current contact info
- **Important**: Troubleshooting section, architecture overview, configuration options
- **Nice to Have**: Detailed examples, performance guides, advanced features

**Output Format**
- List of issues found with severity (Critical/High/Medium/Low)
- Specific file locations and line numbers
- Actionable recommendations for fixes
- Overall documentation health score
- Advanced configuration options
- Video tutorials or demos

### Compliance Standards

**Security Documentation**
- No secrets or sensitive data exposed
- Security configuration properly documented
- Access control requirements clear
- Backup and recovery procedures documented

**Legal and Compliance**
- Appropriate license files
- Attribution for external content
- Privacy policy references where applicable
- Terms of use for public-facing documentation

## Output Format

### Review Report Structure

1. **Summary**: Overall documentation health score
2. **Critical Issues**: Immediate action required
3. **Improvement Opportunities**: Enhancement suggestions
4. **Best Practices**: Compliance with standards
5. **Maintenance Recommendations**: Ongoing care suggestions

### Action Items

**Priority Levels**
- **P0 (Critical)**: Blocking issues, fix immediately
- **P1 (High)**: Important improvements, next sprint
- **P2 (Medium)**: Quality improvements, next release
- **P3 (Low)**: Nice-to-have enhancements

---

*Reference: [Main Instructions](../copilot-instructions.md)*  
*See also: [Project Structure](../.copilot/PROJECT.md)*
