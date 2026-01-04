---
title: "Resolve Issues"
description: "Analyze and resolve GitHub Issues efficiently with intelligent prioritization and batch processing"
model: sonnet
type: "command"
version: "1.0.0"
allowed-tools: Task, TaskOutput, Bash(gh:*), Bash(git:*), Bash(npm:*), Bash(bun:*), Read, Write, Edit, Grep, Glob, TodoWrite
think: true
author: "roksechs"
source: "https://gist.github.com/roksechs/3f24797d4b4e7519e18b7835c6d8a2d3"
---

## GitHub Issue Resolver

> **Attribution**: This command is from [roksechs](https://gist.github.com/roksechs/3f24797d4b4e7519e18b7835c6d8a2d3)
> Part of the development lifecycle: `/shape-issues` -> `/resolve-issues` -> `/review-pr` -> `/resolve-pr-review-thread`

**IMPORTANT: Use thinking mode throughout this entire workflow to analyze, plan, and execute efficiently.**

Comprehensive automation for resolving GitHub Issues through strategic analysis, prioritization, and efficient implementation.

### Workflow Overview

**Think step by step and use thinking mode to:**

- Analyze current repository state of issues and PRs
- Identify patterns and relationships between issues
- Plan the most efficient implementation approach
- Consider potential conflicts and dependencies

#### Phase 1: Smart Issue Analysis & Prioritization

**With thinking mode, perform comprehensive analysis:**

**1.** **Fetch Issues**: Use `gh issue list` and `gh issue view`. Use the github-cli-patterns skill.

- **Prioritize**: P0 → P1 → P2 → bug → enhancement → documentation
- **Analyze**: creation date, assignees, complexity, dependencies

**2.** **Detect Related Issues**: Group by function, optimize batch size, map dependencies.

**3.** **Check Existing PRs**: `gh pr list` to avoid duplicating ongoing work.

#### Phase 2: Strategic Planning & Implementation

**4.** **TodoWrite**: Break down issues into tasks, track progress, mark completions.

**5.** **Branch & Implement**: `git checkout -b feature/issues-{issue-number}`, follow existing patterns.

**6.** **Quality Assurance**: `bun run typecheck && bun run test:run && bun run build && bun run lint`

#### Phase 3: Professional PR Creation & Finalization

**7.** **Commit & PR Creation**: Follow the issue-linking guidelines.
Use `Closes #issue-number`. Include summary, issues addressed, testing results.

**8.** **Final Validation**: Verify all issues addressed, quality checks pass, PR description complete.

### Execution Strategy

- **Batch related issues** by functionality for efficient PRs
- **Optimize sequence** based on dependencies
- **Split large changes** into focused PRs when needed

### Success Criteria

- All issues addressed, quality checks pass, PR with proper issue linkage

---

**Workflow**: `/shape-issues` → `/resolve-issues` → `/review-pr` → `/resolve-pr-review-thread`
