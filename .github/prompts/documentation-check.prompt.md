Your goal is to review and validate documentation consistency, completeness, and AI-friendliness across the project.

## Documentation Review Checklist

### Structure and Organization

**File Hierarchy**
- Verify proper README.md files at appropriate levels
- Check for consistent directory structure documentation
- Validate cross-reference links between documents
- Ensure logical information architecture

**Required Files**
- Root README.md with project overview
- LICENSE file (consistent across workspace)
- .gitignore appropriate for project type
- CHANGELOG.md for projects with releases

### Content Quality Standards

**README.md Requirements**
- Clear purpose statement at the top
- Quick start/setup instructions
- Usage examples with code blocks
- Cost estimates for cloud resources
- Contact information or contribution guidelines

**Technical Documentation**
- API documentation for services
- Configuration file explanations
- Troubleshooting guides and FAQs
- Architecture diagrams where appropriate

**AI-Friendly Formatting**
- Proper markdown syntax and structure
- Code blocks with language specifications
- Clear section headings and navigation
- Descriptive link text (avoid "click here")

### Consistency Checks

**Writing Style**
- US English spelling and grammar
- Middle/high school reading level
- Consistent terminology throughout
- Professional but approachable tone

**Formatting Standards**
- Line length under 120 characters
- Consistent heading hierarchy (H1 → H2 → H3)
- Proper list formatting with blank lines
- Table formatting for structured data

**Code Examples**
- Working, tested code samples
- Proper syntax highlighting
- Realistic, relevant examples
- Security-conscious examples (no hardcoded secrets)

### Cross-Reference Validation

**Internal Links**
- Verify all internal markdown links work
- Check relative path accuracy
- Validate anchor links to sections
- Ensure consistent link formatting

**External References**
- Check external URLs for accessibility
- Verify external documentation versions
- Update outdated third-party references
- Prefer stable/permalink URLs

**File References**
- Validate file path references in documentation
- Check for moved or renamed files
- Update references after restructuring
- Maintain consistency with actual file structure

### AI Context Optimization

**GitHub Copilot Integration**
- Verify .github/copilot-instructions.md references
- Check .copilot/ directory organization
- Validate prompt file documentation
- Ensure context file cross-references

**Searchability**
- Include relevant keywords for semantic search
- Provide clear section summaries
- Use descriptive file and folder names
- Tag content appropriately

### Version Control Integration

**Git Best Practices**
- Verify .gitignore completeness
- Check for committed secrets or sensitive data
- Validate commit message references in changelogs
- Ensure documentation updates accompany code changes

**Change Documentation**
- Update version numbers consistently
- Document breaking changes clearly
- Maintain accurate change logs
- Reference related issues and pull requests

## Review Process

### Automated Checks

**Markdown Linting**
```bash
# Run markdownlint on all documentation
markdownlint **/*.md

# Check for broken links
markdown-link-check **/*.md
```

**Spell Checking**
```bash
# Check spelling in documentation files
cspell "**/*.md"
```

### Manual Review Areas

**Content Accuracy**
- Verify technical accuracy of all instructions
- Test code examples and commands
- Validate configuration examples
- Check cost estimates and calculations

**User Experience**
- Review from new user perspective
- Check logical flow of information
- Validate setup instructions work end-to-end
- Ensure troubleshooting covers common issues

**Maintenance Currency**
- Update software version references
- Refresh screenshots and examples
- Review external dependency versions
- Update cost estimates and service references

## Quality Gates

### Documentation Completeness

**Essential (Blocking)**
- Root README.md with clear purpose
- Setup instructions that work
- Basic usage examples
- Current contact/support information

**Important (Should Have)**
- Troubleshooting section
- Architecture overview
- Configuration options
- Contributing guidelines

**Nice to Have (Could Have)**
- Detailed examples
- Performance optimization guides
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
