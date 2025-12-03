---
title: "Resolve Issues"
description: "Analyze and resolve GitHub Issues efficiently with intelligent prioritization and batch processing"
type: "command"
version: "1.0.0"
tools: ["*"]
think: true
author: "roksechs"
source: "https://gist.github.com/roksechs/3f24797d4b4e7519e18b7835c6d8a2d3"
---

# GitHub Issue Resolver

> **Attribution**: This command is from [roksechs](https://gist.github.com/roksechs/3f24797d4b4e7519e18b7835c6d8a2d3)
> Part of the development lifecycle: `/rok-shape-issues` -> `/rok-resolve-issues` -> `/rok-review-pr` -> `/rok-respond-to-reviews`

**IMPORTANT: Use thinking mode throughout this entire workflow to analyze, plan, and execute efficiently.**

Comprehensive automation for resolving GitHub Issues through strategic analysis, prioritization, and efficient implementation.

## Workflow Overview

**Think step by step and use thinking mode to:**
- Analyze current repository state of issues and PRs
- Identify patterns and relationships between issues
- Plan the most efficient implementation approach
- Consider potential conflicts and dependencies

### Phase 1: Smart Issue Analysis & Prioritization

**With thinking mode, perform comprehensive analysis:**

1. **Fetch and Analyze All Issues**
   ```bash
   gh issue list
   gh issue view {issue-number} # for each issue
   ```
   - **Priority matrix**: P0 -> P1 -> P2 -> enhancement -> bug -> documentation
   - **Context analysis**: creation date, assignees, comment activity, complexity
   - **Dependency mapping**: blocked issues, prerequisites, urgent fixes

2. **Detect Related Issues**
   - **Functional grouping**: TypeScript, testing, deployment, build tools
   - **Size optimization**: Small docs/config changes for efficient bundling
   - **Dependency analysis**: Issues requiring coordinated implementation
   - **Conflict detection**: Issues that might interfere with each other

3. **Check Existing PRs**
   ```bash
   gh pr list
   gh pr view {pr-number}
   ```
   - Verify no issues have associated PRs in progress
   - Avoid duplicating ongoing development work

### Phase 2: Strategic Planning & Implementation

4. **Use TodoWrite for Progress Management**
   - Break down selected issues into specific, actionable tasks
   - Establish implementation order considering dependencies
   - Track progress throughout the workflow with real-time updates
   - Mark completion status as tasks are finished

5. **Branch Creation & Systematic Implementation**
   ```bash
   git checkout -b feature/issues-{main-issue-number}
   ```
   - Implement each requirement following systematic approach
   - Consider: file structure, configuration, documentation
   - Follow existing code patterns and architectural conventions
   - Maintain backward compatibility and minimize breaking changes

6. **Comprehensive Quality Assurance**
   ```bash
   # Run complete quality check suite
   npm run typecheck || bun run typecheck
   npm run test:run || bun run test:run
   npm run build || bun run build
   npm run lint || bun run lint
   ```
   - Ensure all tests pass without failures
   - Verify TypeScript compilation succeeds
   - Confirm successful builds for all environments
   - Check for and resolve linting issues

### Phase 3: Professional PR Creation & Finalization

7. **Commit & PR Creation**
   - Create meaningful commit messages following conventional patterns
   - Use `Closes #issue-number` for automatic issue closure
   - Write comprehensive PR descriptions including:
     - Executive summary of changes
     - Complete list of issues addressed
     - Testing performed and results
     - Breaking changes (if any)
     - Future considerations and next steps
   - Link all related issues with proper references

8. **Final Quality Validation**
   - Verify all selected issues are fully addressed
   - Ensure PR description is comprehensive and clear
   - Confirm all quality checks pass successfully
   - Review implementation for completeness and consistency

## Strategic Execution Framework

<workflow_example>
**Analysis Patterns:**

<current_state>
- High-priority architecture enhancement affecting core systems
- Related enhancement with synergistic benefits
- Standalone feature enhanced by architectural changes
- Tooling migration affecting build pipeline
- Documentation updates for technology changes
</current_state>

<relationship_patterns>
- Foundation technology + dependent enhancement = synergistic benefits
- Core architecture + standalone feature = enhanced functionality
- Tooling migration + existing commands = coordinated updates
- Technology changes + documentation = comprehensive updates
</relationship_patterns>

<implementation_approach>
1. Create feature branch for primary architectural issue
2. Implement foundational changes
3. Add synergistic enhancements
4. Apply coordinated tooling updates
5. Implement enhanced features
6. Update comprehensive documentation
7. Create PR linking all related work
</implementation_approach>
</workflow_example>

## Intelligent Adaptation Features

**Use thinking mode to:**
- **Pattern Learning**: Analyze past successful issue combinations for optimization
- **Sequence Optimization**: Determine most efficient implementation order
- **Conflict Resolution**: Intelligently resolve competing requirements
- **Scope Management**: Decide when to split large changes into focused PRs

## Success Criteria

- All selected issues are comprehensively addressed
- Related issues are strategically batched for maximum efficiency
- Complete quality assurance (tests, typecheck, build, lint)
- PR has detailed description with proper issue linkage
- Documentation accurately reflects all implemented changes
- Implementation follows best practices and coding standards

## Advanced Features

### Smart Batching
- Automatically group related issues by functionality
- Optimize for development efficiency and review clarity
- Balance PR size with logical coherence

### Quality Gates
- Comprehensive testing before PR creation
- Automated verification of all requirements
- Consistent code quality enforcement

### Learning System
- Adapt strategies based on repository patterns
- Improve efficiency through historical analysis
- Optimize for team workflow preferences

---

**EXECUTION INSTRUCTION**:

**Think step by step and use thinking mode extensively.** Analyze the current repository state, identify high-priority issues and their relationships, create an efficient implementation plan, execute the changes systematically, and ensure quality throughout. Focus on creating comprehensive, well-tested solutions that address multiple related concerns efficiently.

**Workflow Integration**:
- **Before implementation**: Use `/rok-shape-issues` for iterative Issue shaping and appetite-based planning
- **After implementation**: Use `/rok-review-pr` for comprehensive PR review, then `/rok-respond-to-reviews` for feedback resolution

**Complete Development Lifecycle**: `/rok-shape-issues` -> `/rok-resolve-issues` -> `/rok-review-pr` -> `/rok-respond-to-reviews`
