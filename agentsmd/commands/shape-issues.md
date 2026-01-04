---
title: "Shape Issues"
description: "Shape raw ideas into actionable GitHub Issues using iterative exploration and timebox-based prioritization"
model: opus
type: "command"
version: "1.0.0"
allowed-tools: Task, TaskOutput, AskUserQuestion, Bash(gh:*), WebFetch, Read, Grep, Glob, WebSearch, TodoWrite
think: true
author: "roksechs"
source: "https://gist.github.com/roksechs/3f24797d4b4e7519e18b7835c6d8a2d3"
---

## Issue Shaping Workshop

> **Attribution**: This command is from [roksechs](https://gist.github.com/roksechs/3f24797d4b4e7519e18b7835c6d8a2d3)
> Part of the development lifecycle:
> `/shape-issues` -> `/resolve-issues` -> `/review-pr` -> `/resolve-pr-review-thread`

Iterative Issue exploration and shaping process that transforms rough ideas into well-defined,
time-boxed GitHub Issues using Shape Up methodology and continuous discovery principles.

### Phases

1. **Problem Exploration**: Examine raw ideas, map pain points, assess timebox
2. **Solution Sketching**: Brainstorm approaches, set scope boundaries, identify risks
3. **Issue Formation**: Problem statement, timebox, solution sketch, rabbit holes
4. **Betting Table**: Prioritize by timebox, balance portfolio, set circuit breakers
5. **Issue Crafting**: Create GitHub Issues with size labels, handoff to `/resolve-issues`

### Sizing

`size:xs` (< 1 day), `size:s` (1-3 days), `size:m` (3-5 days), `size:l` (1-2 weeks), `size:xl` (2+ weeks)

### Workflow

1. Gather context: `gh issue list`, `gh pr list` - see [GitHub CLI Patterns](../skills/github-cli-patterns/SKILL.md)
2. Explore problem: user complaints, workflow friction, timebox check
3. Sketch solutions: 2-3 approaches, scope boundaries, rabbit holes
4. Set timebox: spike vs small batch vs big batch
5. Create issue: `gh issue create` with template below, add `ready-for-dev` label

### Issue Template

See [GitHub Issue Standards](../rules/github-issue-standards.md) for full template.

Key sections: Problem (raw idea, pain, size), Solution Sketch (concept, out of scope),
Rabbit Holes (complexity traps), Done Looks Like (acceptance criteria).

### Usage

**Command**: `/shape-issues`

**Workflow**: `/shape-issues` → `/resolve-issues` → `/review-pr` → `/resolve-pr-review-thread`

**Reference**: [GitHub Issue Standards](../rules/github-issue-standards.md)
