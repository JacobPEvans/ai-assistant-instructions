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

### Core Capabilities

**Phase 1: Problem Exploration & Context Discovery** (problem_exploration)

- **Raw idea examination**: Start with fuzzy problems, user complaints, or opportunities
- **Current pain point mapping**: Understand what's actually broken or missing
- **User journey analysis**: Walk through existing workflows to spot friction
- **"Jobs to be Done" framing**: What are users really trying to accomplish?
- **Timebox assessment**: How much time/effort is this problem worth?

**Phase 2: Solution Sketching & Boundary Setting** (solution_sketching)

- **Solution space exploration**: Brainstorm multiple approaches, not just one
- **Scope boundaries**: Define what's included and (critically) what's excluded
- **Technical approach options**: Identify different implementation paths
- **Risk identification**: What could go wrong? What are the unknowns?
- **Circuit breaker**: Set maximum time investment before re-evaluation

**Phase 3: Issue Formation & Shape Definition** (issue_formation)

- **Problem statement**: Clear, specific description of what we're solving
- **Timebox definition**: Small batch (1-2 weeks) vs. Big batch (6 weeks) vs. Investigation spike
- **Solution sketch**: Rough mockups, key technical decisions, not detailed specs
- **Rabbit holes to avoid**: List known complexity traps and scope creep risks
- **Done looks like**: High-level acceptance criteria, not exhaustive requirements

**Phase 4: Betting Table & Portfolio Balancing** (betting_table)

- **Timebox-based prioritization**: Match problems to available time budgets
- **Portfolio mix**: Balance new features, bug fixes, and technical debt
- **Cool-down periods**: Plan for bug fixes and small improvements between cycles
- **Capacity reality check**: What can actually be accomplished this cycle?
- **Circuit breaker setup**: Define when to stop and re-evaluate if things go wrong

**Phase 5: GitHub Issue Crafting & Team Handoff** (issue_crafting)

- **Shaped Issue creation**: Transform shapes into actionable GitHub Issues
- **Size labeling**: xs/s/m/l/xl labels for scope estimation
- **Solution sketch attachment**: Include rough wireframes, technical notes
- **Rabbit hole documentation**: List known risks and scope boundaries
- **Ready-for-development**: Clear handoff to `/resolve-issues` phase

### Shape Up Frameworks

> **Analysis Frameworks:**

#### Timebox Assessment Framework

```text
Small Batch (1-2 weeks): Quick fixes, minor improvements, spikes
Big Batch (6 weeks): New features, significant changes, major refactors
Investigation Spike: Unknown complexity, research needed
No Timebox: Not worth any time investment right now
```

#### Circuit Breaker Indicators

```bash
# Monitor for signs to stop and re-evaluate
git log --oneline --since="1 week ago" --grep="WIP\|TODO\|FIXME" | wc -l
gh pr list --label "blocked" --state open
gh issue list --label "rabbit-hole" --state open
```

#### Problem Freshness Check

```text
Fresh Problem: Users actively complaining, clear pain point
Nice-to-Have: Theoretical improvement, no urgent user demand
Pet Feature: Developer/stakeholder desire, unclear user value
Technical Debt: Internal quality issue affecting development speed
```

### Issue Shaping Workflow

> **Workflow Steps:**

#### Step 1: Raw Idea Collection & Context Gathering

```bash
# Gather current project state and ongoing issues
gh issue list --state open --json title,labels,body,comments
gh issue list --state closed --since 30d --json title,labels,closedAt
gh pr list --state all --json title,mergedAt,labels
```

#### Step 2: Problem Space Exploration

- **User complaint analysis**: What are people actually struggling with?
- **Workflow friction mapping**: Where do things get slow or confusing?
- **"What would good look like?"**: Paint the picture of success without diving into solution details
- **Timebox check**: How much time is this problem worth?

#### Step 3: Solution Space Sketching

- **Multiple solution approaches**: Brainstorm 2-3 different ways to solve this
- **Scope boundary drawing**: What's definitely IN vs. definitely OUT?
- **Technical risk identification**: What could go sideways? What are the unknowns?
- **Rabbit hole mapping**: List the complexity traps to avoid

#### Step 4: Timebox Setting & Betting

- **Time boxing**: Is this a 1-week spike, 2-week small batch, or 6-week big batch?
- **Portfolio balancing**: Mix of new features, bug fixes, and improvements
- **Circuit breaker setting**: When should we stop and re-evaluate?
- **Cool-down planning**: What small improvements can we do between big projects?

#### Step 5: Issue Crafting & Handoff

```bash
# Create shaped Issues ready for development
gh issue create --title "[Small Batch] Add user preference validation" \
  --body "Size: l (1-2 weeks)
Problem: Users confused by unclear error messages
Solution sketch: Add client-side validation with clear feedback
Rabbit holes: Don't rebuild entire form system"

# Label with size and readiness
gh label create "size:m" --color "00ff00" \
  --description "Medium (3-5 days)"
gh label create "size:l" --color "ff9900" \
  --description "Large (1-2 weeks)"
gh label create "ready-for-dev" --color "0099ff" \
  --description "Shaped and ready for /resolve-issues"
```

### Shape Up Excellence Standards

> **Best Practices:**

#### Timebox-Driven Development

- **Time-boxed thinking**: Fixed time, variable scope instead of fixed scope, variable time
- **Problem-first approach**: Start with user problems, not solution ideas
- **Timebox before features**: Set time budget before diving into solution details
- **Circuit breaker discipline**: Know when to stop and re-evaluate

#### Continuous Shaping

- **Iterative refinement**: Shapes evolve through multiple rounds of exploration
- **Scope hammering**: Continuously remove features to fit timebox
- **Risk de-risking**: Address biggest unknowns early in shaping
- **Solution diversity**: Explore multiple approaches before settling on one

#### Cool-Down Wisdom

- **Breathing room**: Plan cool-down periods between big projects
- **Small batch opportunities**: Use gaps for quick wins and minor improvements
- **Technical debt paydown**: Address accumulated complexity during downtime
- **Team energy management**: Balance challenging work with easier maintenance tasks

### Shaped Issue Templates

> **Issue Templates:**

#### Shaped Issue Template

```markdown
## Problem

**Raw idea**: [The initial fuzzy idea or user complaint]
**Current pain**: [What's broken or frustrating users right now]
**Size**: [xs | s | m | l | xl]

## Solution Sketch

**Core concept**: [High-level approach, not detailed requirements]
**Key elements**: [Main components or workflow changes]
**Out of scope**: [What we're explicitly NOT doing]

## Rabbit Holes

- [Complexity trap #1 to avoid]
- [Scope creep risk #2 to avoid]
- [Technical rabbit hole #3 to avoid]

## No-Gos

- [Things that would kill this project]
- [Scope that would exceed timebox]

## Done Looks Like

- [ ] [Acceptance criterion 1 - specific and measurable]
- [ ] [Acceptance criterion 2 - specific and measurable]

## Verification Steps

- [ ] [How to verify criterion 1]
- [ ] [How to verify criterion 2]
- [ ] [Manual or automated test to confirm]

## Metadata

**Assignee**: [GitHub username or unassigned]
**Milestone**: [Target milestone or none]
**Project**: [Project board or none]
**Related Issues**:
- Blocks: #XX
- Blocked by: #YY
- Related to: #ZZ
```

#### Size Classification

```text
size:xs - Extra small (< 1 day): Spikes, research, investigation
size:s  - Small (1-3 days): Bug fixes, minor improvements, quick wins
size:m  - Medium (3-5 days): Standard features, moderate changes
size:l  - Large (1-2 weeks): New features, significant changes
size:xl - Extra large (2+ weeks): Major refactors, complex systems
```

### Usage Instructions

> **Usage:**
>
> **Command Execution**: `/shape-issues`
>
> **Example Prompts**:
>
> - "Shape the user login confusion problem into actionable Issues"
> - "Explore timebox and solution approaches for mobile performance complaints"
> - "Transform vague 'improve dashboard' idea into shaped Issues with time boundaries"
> - "Shape payment integration opportunity with proper scope and rabbit hole identification"
> - "Take raw user feedback about search and shape it into development-ready Issues"

**Workflow Integration**:

- **Feeds into**: `/resolve-issues` (shaped Issue implementation)
- **Iterative process**: Continuously shape and re-shape ideas based on learning
- **Outputs**: Time-boxed, well-scoped Issues ready for development

**Complete Development Lifecycle**:
`/shape-issues` -> `/resolve-issues` -> `/review-pr` -> `/resolve-pr-review-thread`

This command transforms raw ideas into actionable, time-bounded Issues using Shape Up principles
of timebox-driven development and iterative shaping.

**Reference**: See [GitHub Issue Standards](../rules/github-issue-standards.md) for comprehensive best practices.
