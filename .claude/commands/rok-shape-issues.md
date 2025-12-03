---
title: "Shape Issues"
description: "Shape raw ideas into actionable GitHub Issues using iterative exploration and appetite-based prioritization"
type: "command"
version: "1.0.0"
tools: ["*"]
think: true
author: "roksechs"
source: "https://gist.github.com/roksechs/3f24797d4b4e7519e18b7835c6d8a2d3"
---

# Issue Shaping Workshop

> **Attribution**: This command is from [roksechs](https://gist.github.com/roksechs/3f24797d4b4e7519e18b7835c6d8a2d3)
> Part of the development lifecycle: `/rok-shape-issues` -> `/rok-resolve-issues` -> `/rok-review-pr` -> `/rok-respond-to-reviews`

Iterative Issue exploration and shaping process that transforms rough ideas into well-defined, time-boxed GitHub Issues using Shape Up methodology and continuous discovery principles.

## Core Capabilities

<phase name="problem_exploration">
### Phase 1: Problem Exploration & Context Discovery
- **Raw idea examination**: Start with fuzzy problems, user complaints, or opportunities
- **Current pain point mapping**: Understand what's actually broken or missing
- **User journey analysis**: Walk through existing workflows to spot friction
- **"Jobs to be Done" framing**: What are users really trying to accomplish?
- **Appetite assessment**: How much time/effort is this problem worth?
</phase>

<phase name="solution_sketching">
### Phase 2: Solution Sketching & Boundary Setting
- **Solution space exploration**: Brainstorm multiple approaches, not just one
- **Scope boundaries**: Define what's included and (critically) what's excluded
- **Technical approach options**: Identify different implementation paths
- **Risk identification**: What could go wrong? What are the unknowns?
- **Circuit breaker**: Set maximum time investment before re-evaluation
</phase>

<phase name="issue_formation">
### Phase 3: Issue Formation & Shape Definition
- **Problem statement**: Clear, specific description of what we're solving
- **Appetite definition**: Small batch (1-2 weeks) vs. Big batch (6 weeks) vs. Investigation spike
- **Solution sketch**: Rough mockups, key technical decisions, not detailed specs
- **Rabbit holes to avoid**: List known complexity traps and scope creep risks
- **Done looks like**: High-level acceptance criteria, not exhaustive requirements
</phase>

<phase name="betting_table">
### Phase 4: Betting Table & Portfolio Balancing
- **Appetite-based prioritization**: Match problems to available time budgets
- **Portfolio mix**: Balance new features, bug fixes, and technical debt
- **Cool-down periods**: Plan for bug fixes and small improvements between cycles
- **Capacity reality check**: What can actually be accomplished this cycle?
- **Circuit breaker setup**: Define when to stop and re-evaluate if things go wrong
</phase>

<phase name="issue_crafting">
### Phase 5: GitHub Issue Crafting & Team Handoff
- **Shaped Issue creation**: Transform shapes into actionable GitHub Issues
- **Appetite labeling**: Small-batch, big-batch, or spike labels
- **Solution sketch attachment**: Include rough wireframes, technical notes
- **Rabbit hole documentation**: List known risks and scope boundaries
- **Ready-for-development**: Clear handoff to `/rok-resolve-issues` phase
</phase>

## Shape Up Frameworks

<analysis_frameworks>
### Appetite Assessment Framework
```
Small Batch (1-2 weeks): Quick fixes, minor improvements, spikes
Big Batch (6 weeks): New features, significant changes, major refactors
Investigation Spike: Unknown complexity, research needed
No Appetite: Not worth any time investment right now
```

### Circuit Breaker Indicators
```bash
# Monitor for signs to stop and re-evaluate
git log --oneline --since="1 week ago" --grep="WIP\|TODO\|FIXME" | wc -l
gh pr list --label "blocked" --state open
gh issue list --label "rabbit-hole" --state open
```

### Problem Freshness Check
```
Fresh Problem: Users actively complaining, clear pain point
Nice-to-Have: Theoretical improvement, no urgent user demand
Pet Feature: Developer/stakeholder desire, unclear user value
Technical Debt: Internal quality issue affecting development speed
```
</analysis_frameworks>

## Issue Shaping Workflow

<workflow_steps>
### Step 1: Raw Idea Collection & Context Gathering
```bash
# Gather current project state and ongoing issues
gh issue list --state open --json title,labels,body,comments
gh issue list --state closed --since 30d --json title,labels,closedAt
gh pr list --state all --json title,mergedAt,labels
```

### Step 2: Problem Space Exploration
- **User complaint analysis**: What are people actually struggling with?
- **Workflow friction mapping**: Where do things get slow or confusing?
- **"What would good look like?"**: Paint the picture of success without diving into solution details
- **Appetite check**: How much time is this problem worth?

### Step 3: Solution Space Sketching
- **Multiple solution approaches**: Brainstorm 2-3 different ways to solve this
- **Scope boundary drawing**: What's definitely IN vs. definitely OUT?
- **Technical risk identification**: What could go sideways? What are the unknowns?
- **Rabbit hole mapping**: List the complexity traps to avoid

### Step 4: Appetite Setting & Betting
- **Time boxing**: Is this a 1-week spike, 2-week small batch, or 6-week big batch?
- **Portfolio balancing**: Mix of new features, bug fixes, and improvements
- **Circuit breaker setting**: When should we stop and re-evaluate?
- **Cool-down planning**: What small improvements can we do between big projects?

### Step 5: Issue Crafting & Handoff
```bash
# Create shaped Issues ready for development
gh issue create --title "[Small Batch] Add user preference validation" --body "Appetite: 2 weeks\nProblem: Users confused by unclear error messages\nSolution sketch: Add client-side validation with clear feedback\nRabbit holes: Don't rebuild entire form system"

# Label with appetite and readiness
gh label create "appetite:small-batch" --color "00ff00" --description "1-2 week time box"
gh label create "appetite:big-batch" --color "ff9900" --description "6 week time box"
gh label create "ready-for-dev" --color "0099ff" --description "Shaped and ready for /rok-resolve-issues"
```
</workflow_steps>

## Shape Up Excellence Standards

<best_practices>
### Appetite-Driven Development
- **Time-boxed thinking**: Fixed time, variable scope instead of fixed scope, variable time
- **Problem-first approach**: Start with user problems, not solution ideas
- **Appetite before features**: Set time budget before diving into solution details
- **Circuit breaker discipline**: Know when to stop and re-evaluate

### Continuous Shaping
- **Iterative refinement**: Shapes evolve through multiple rounds of exploration
- **Scope hammering**: Continuously remove features to fit appetite
- **Risk de-risking**: Address biggest unknowns early in shaping
- **Solution diversity**: Explore multiple approaches before settling on one

### Cool-Down Wisdom
- **Breathing room**: Plan cool-down periods between big projects
- **Small batch opportunities**: Use gaps for quick wins and minor improvements
- **Technical debt paydown**: Address accumulated complexity during downtime
- **Team energy management**: Balance challenging work with easier maintenance tasks
</best_practices>

## Shaped Issue Templates

<issue_templates>
### Shaped Issue Template
```markdown
## Problem
**Raw idea**: [The initial fuzzy idea or user complaint]
**Current pain**: [What's broken or frustrating users right now]
**Appetite**: [Small batch: 1-2 weeks | Big batch: 6 weeks | Spike: investigate]

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
- [Scope that would exceed appetite]

## Done Looks Like
- [High-level success indicator 1]
- [High-level success indicator 2]
```

### Appetite Classification
```
Small Batch (1-2 weeks): Bug fixes, minor improvements, quick wins
Big Batch (6 weeks): New features, significant changes, major refactors
Spike (timebox): Research unknowns, technical investigation, feasibility study
Cool-Down: Small improvements, bug fixes, maintenance tasks
```
</issue_templates>

## Usage Instructions

<usage>
**Command Execution**: `/rok-shape-issues`

**Example Prompts**:
- "Shape the user login confusion problem into actionable Issues"
- "Explore appetite and solution approaches for mobile performance complaints"
- "Transform vague 'improve dashboard' idea into shaped Issues with time boundaries"
- "Shape payment integration opportunity with proper scope and rabbit hole identification"
- "Take raw user feedback about search and shape it into development-ready Issues"
</usage>

**Workflow Integration**:
- **Feeds into**: `/rok-resolve-issues` (shaped Issue implementation)
- **Iterative process**: Continuously shape and re-shape ideas based on learning
- **Outputs**: Time-boxed, well-scoped Issues ready for development

**Complete Development Lifecycle**: `/rok-shape-issues` -> `/rok-resolve-issues` -> `/rok-review-pr` -> `/rok-respond-to-reviews`

This command transforms raw ideas into actionable, time-bounded Issues using Shape Up principles of appetite-driven development and iterative shaping.
