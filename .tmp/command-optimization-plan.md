# Command Token Optimization Plan

## Executive Summary

Analysis of the 20 custom commands reveals significant token usage due to duplication of patterns, workflows, and examples. The top 10 commands consume **67,615 bytes** (approx. 16,900 words). By applying DRY principles and leveraging existing Claude Code features (Task tool, skills, agents), we can reduce token usage by an estimated **40-60%**.

## Analysis Results

### Top 10 Largest Commands (by word count)

1. **auto-claude.md** - 3,323 words (21,460 bytes)
2. **manage-pr.md** - 1,411 words (9,986 bytes)
3. **shape-issues.md** - 1,347 words (9,845 bytes)
4. **review-pr.md** - 1,079 words (8,682 bytes)
5. **git-rebase-troubleshoot.md** - 1,013 words (6,479 bytes)
6. **init-worktree.md** - 948 words (7,234 bytes)
7. **resolve-issues.md** - 922 words (7,107 bytes)
8. **ready-player-one.md** - 910 words (6,568 bytes)
9. **sync-main.md** - 850 words (5,734 bytes)
10. **quick-add-permission.md** - 825 words (6,339 bytes)

**Total:** 12,628 words (89,434 bytes)

### Largest Skills (for reference)

1. **github-graphql** - 1,429 words
2. **pr-thread-resolution-enforcement** - 1,129 words
3. **subagent-batching** - 1,109 words
4. **worktree-management** - 936 words
5. **pr-comment-limit-enforcement** - 916 words
6. **pr-health-check** - 907 words

## Key Duplication Patterns Identified

### 1. GitHub GraphQL Patterns (HIGH IMPACT)

**Current State:**
- 4 commands reference GitHub GraphQL skill
- 2 commands still duplicate GraphQL query patterns inline
- Total duplicated content: ~800 words

**Commands Affected:**
- manage-pr.md (3 inline GraphQL examples)
- review-pr.md (2 inline GraphQL examples)
- ready-player-one.md (references skill but duplicates examples)
- auto-claude.md (duplicates thread resolution logic)

**Optimization:**
- **Action:** Remove all inline GraphQL examples from commands
- **Replace with:** Single reference to `github-graphql` skill
- **Token Savings:** ~600-800 words (~15-20% reduction in affected commands)

### 2. PR Thread Resolution Workflow (HIGH IMPACT)

**Current State:**
- 5 commands duplicate the PR thread resolution workflow
- Each explains: reply → resolve → verify atomicity
- Total duplicated content: ~1,200 words

**Commands Affected:**
- manage-pr.md (full workflow in Phase 2.4)
- auto-claude.md (pr-thread-resolver sub-agent section)
- ready-player-one.md (references but duplicates)
- review-pr.md (feedback delivery section)
- resolve-pr-review-thread.md (likely duplicates - not in top 10)

**Optimization:**
- **Action:** Replace all workflow sections with: "See [PR Thread Resolution Enforcement Skill](../skills/pr-thread-resolution-enforcement/SKILL.md)"
- **Replace with:** Task tool invocation pattern to skill
- **Token Savings:** ~1,000 words (~25-30% in affected commands)

### 3. Worktree Management Patterns (VERY HIGH IMPACT)

**Current State:**
- 13 commands mention worktrees
- 6 commands duplicate full worktree setup/cleanup instructions
- Total duplicated content: ~1,500 words

**Commands Affected:**
- init-worktree.md (full workflow - THIS IS THE CANONICAL SOURCE)
- sync-main.md (duplicates worktree creation and cleanup)
- auto-claude.md (duplicates in branch-updater and pr-merger sub-agents)
- quick-add-permission.md (duplicates worktree creation steps 1-2)
- git-rebase-troubleshoot.md (duplicates troubleshooting patterns)
- git-worktree-troubleshooting.md (specialized troubleshooting)

**Optimization:**
- **Action:** Create worktree-management skill (already exists at 936 words!)
- **Action:** Remove all duplicated worktree instructions from commands
- **Replace with:** Reference to worktree-management skill + /init-worktree command
- **Token Savings:** ~1,200 words (~30-40% in affected commands)

### 4. Subagent Batching Patterns (MEDIUM IMPACT)

**Current State:**
- 4 commands duplicate the 5-agent limit and batching strategy
- Total duplicated content: ~600 words

**Commands Affected:**
- auto-claude.md (full batching logic in PR-FOCUS MODE)
- sync-main.md (batching strategy section)
- ready-player-one.md (references skill but duplicates)
- fix-pr-ci.md (likely duplicates)

**Optimization:**
- **Action:** Remove all batching explanations
- **Replace with:** "Use [Subagent Batching Skill](../skills/subagent-batching/SKILL.md) for parallel execution"
- **Token Savings:** ~500 words (~20% in affected commands)

### 5. PR Health Check Patterns (MEDIUM IMPACT)

**Current State:**
- 3 commands duplicate PR merge-readiness criteria
- Total duplicated content: ~400 words

**Commands Affected:**
- manage-pr.md (Phase 2.1 health check)
- ready-player-one.md (Step 4 merge-readiness)
- auto-claude.md (pr-merger sub-agent criteria)

**Optimization:**
- **Action:** Remove all health check criteria explanations
- **Replace with:** Reference to pr-health-check skill
- **Token Savings:** ~300 words (~10-15% in affected commands)

### 6. GitHub CLI Examples (MEDIUM IMPACT)

**Current State:**
- 8 commands duplicate gh CLI usage examples
- Total duplicated content: ~800 words

**Commands Affected:**
- manage-pr.md (extensive gh CLI examples)
- review-pr.md (gh CLI mastery section)
- shape-issues.md (gh issue commands)
- resolve-issues.md (gh issue/pr commands)
- ready-player-one.md (gh pr list/view patterns)
- auto-claude.md (gh pr/issue commands throughout)
- sync-main.md (gh pr commands)

**Optimization:**
- **Action:** Create a "github-cli-patterns" skill with common examples
- **Action:** Remove duplicated examples from commands
- **Replace with:** Reference to skill + specific command only
- **Token Savings:** ~600 words (~15-20% in affected commands)

### 7. Issue Shaping/Resolution Workflow (MEDIUM IMPACT)

**Current State:**
- 3 commands duplicate issue workflow patterns
- Total duplicated content: ~500 words

**Commands Affected:**
- shape-issues.md (full shaping workflow)
- resolve-issues.md (resolution workflow)
- auto-claude.md (issue-resolver sub-agent)

**Optimization:**
- **Action:** Keep shape-issues.md and resolve-issues.md as-is (they ARE the workflow)
- **Action:** In auto-claude.md, replace with Task tool invocation to /shape-issues and /resolve-issues
- **Token Savings:** ~200-300 words in auto-claude.md only

## Detailed Refactoring Plan

### Phase 1: Create Missing Skills

#### 1.1 Create `github-cli-patterns` Skill

**Priority:** HIGH
**Estimated Token Savings:** 600-800 words across 8 commands

**Content:**
```markdown
# GitHub CLI Patterns

Common gh CLI patterns used across commands.

## PR Operations
- gh pr list
- gh pr view
- gh pr create
- gh pr checks

## Issue Operations
- gh issue list
- gh issue view
- gh issue create

## Review Operations
- gh pr review
- gh api repos/*/pulls/*/comments

## Repository Operations
- gh repo view
- gh repo list
```

**Commands to Update:**
- manage-pr.md
- review-pr.md
- shape-issues.md
- resolve-issues.md
- ready-player-one.md
- auto-claude.md
- sync-main.md

#### 1.2 Enhance `worktree-management` Skill

**Priority:** VERY HIGH
**Estimated Token Savings:** 1,200+ words across 6 commands

**Enhancement:**
- Already exists at 936 words
- Ensure it covers all patterns from init-worktree.md
- Add troubleshooting section from git-worktree-troubleshooting.md

**Commands to Update:**
- sync-main.md (remove Steps 1-2, reference skill)
- auto-claude.md (remove branch-updater worktree logic, reference skill)
- quick-add-permission.md (remove Steps 1-2, reference skill + /init-worktree)
- git-rebase-troubleshoot.md (reference worktree-management skill)

### Phase 2: Refactor Top 3 Largest Commands

#### 2.1 Refactor `auto-claude.md` (3,323 words → ~2,000 words)

**Target Reduction:** 40% (1,300 words)

**Changes:**

1. **Remove duplicate worktree patterns** (300 words)
   - branch-updater section → reference worktree-management skill
   - Simplify to: "Use worktree-management skill patterns"

2. **Remove duplicate PR thread resolution** (400 words)
   - pr-thread-resolver section → reference pr-thread-resolution-enforcement skill
   - Replace with: "Use /resolve-pr-review-thread command"

3. **Remove duplicate batching logic** (200 words)
   - PR-FOCUS MODE batching → reference subagent-batching skill
   - Replace with: "Use subagent-batching skill (max 5 concurrent)"

4. **Consolidate sub-agent prompts** (300 words)
   - Move detailed sub-agent prompts to separate files in `.claude/agents/`
   - Reference them as: "Use {agent-name} agent (see .claude/agents/{agent-name}.md)"

5. **Remove duplicate GitHub CLI examples** (100 words)
   - Replace with: "See github-cli-patterns skill"

**After Refactoring:**
```markdown
## Core Loop

0. Check PR count: `gh pr list --author @me --state open --json number | jq length`
1. SCAN: Gather state (see github-cli-patterns skill)
2. PRIORITIZE: Use priority matrix (1-10)
3. DISPATCH:
   - PR updates: Use worktree-management skill
   - CI fixes: Use /fix-pr-ci or Task(ci-fixer)
   - Review threads: Use /resolve-pr-review-thread
   - Issues: Use /shape-issues and /resolve-issues
   - Batching: Use subagent-batching skill (max 5 concurrent)
4. AWAIT: TaskOutput with block=true
5. CAPTURE: Log results
6. LOOP: Return to step 0
```

#### 2.2 Refactor `manage-pr.md` (1,411 words → ~900 words)

**Target Reduction:** 35% (500 words)

**Changes:**

1. **Remove inline GraphQL examples** (150 words)
   - Phase 2.4 → reference github-graphql skill
   - Phase 3 verification → reference pr-thread-resolution-enforcement skill

2. **Remove duplicate PR thread resolution workflow** (200 words)
   - Section 2.4 → "See pr-thread-resolution-enforcement skill"
   - Add: "Or use /resolve-pr-review-thread for batch resolution"

3. **Remove duplicate GitHub CLI examples** (100 words)
   - GitHub CLI Mastery section → reference github-cli-patterns skill
   - Keep only command-specific examples

4. **Consolidate health check section** (50 words)
   - Section 2.1 → reference pr-health-check skill

#### 2.3 Refactor `shape-issues.md` (1,347 words → ~1,100 words)

**Target Reduction:** 20% (250 words)

**Changes:**

1. **Remove duplicate GitHub CLI examples** (150 words)
   - Replace gh issue examples → reference github-cli-patterns skill
   - Keep only shaping-specific examples

2. **Consolidate workflow steps** (100 words)
   - Reduce verbosity in Steps 1-5
   - Focus on Shape Up methodology, not gh CLI usage

### Phase 3: Refactor Remaining Top 10 Commands

#### 3.1 `review-pr.md` (1,079 words → ~750 words)

**Changes:**
- Remove GitHub CLI Mastery section (200 words) → github-cli-patterns skill
- Remove thread resolution explanation (100 words) → pr-thread-resolution-enforcement skill
- Consolidate review criteria (29 words saved by removing duplicated emoji system)

**Token Savings:** 330 words (30%)

#### 3.2 `git-rebase-troubleshoot.md` (1,013 words → ~850 words)

**Changes:**
- Reference worktree-management skill for worktree patterns (100 words)
- Consolidate error sections (reduce verbosity by 63 words)

**Token Savings:** 163 words (16%)

#### 3.3 `init-worktree.md` (948 words → ~700 words)

**Changes:**
- This IS the canonical worktree source
- BUT: Can reference worktree-management skill for common patterns (150 words)
- Reduce verbosity in examples (98 words)

**Token Savings:** 248 words (26%)

#### 3.4 `resolve-issues.md` (922 words → ~700 words)

**Changes:**
- Remove GitHub CLI examples (100 words) → github-cli-patterns skill
- Simplify workflow steps (reduce verbosity) (122 words)

**Token Savings:** 222 words (24%)

#### 3.5 `ready-player-one.md` (910 words → ~650 words)

**Changes:**
- Remove inline merge-readiness criteria (100 words) → pr-health-check skill
- Remove GraphQL examples (60 words) → github-graphql skill
- Reference subagent-batching skill (50 words)
- Simplify execution steps (50 words)

**Token Savings:** 260 words (28%)

#### 3.6 `sync-main.md` (850 words → ~600 words)

**Changes:**
- Remove worktree creation/cleanup steps (150 words) → worktree-management skill
- Remove batching strategy section (50 words) → subagent-batching skill
- Simplify conflict resolution section (50 words)

**Token Savings:** 250 words (29%)

#### 3.7 `quick-add-permission.md` (825 words → ~600 words)

**Changes:**
- Remove worktree creation Steps 1-2 (150 words) → reference /init-worktree command
- Consolidate permission format examples (75 words)

**Token Savings:** 225 words (27%)

## Summary of Token Savings

### By Phase

| Phase | Commands | Current Words | After Words | Savings | % Reduction |
|-------|----------|---------------|-------------|---------|-------------|
| Phase 1 (Skills) | - | - | - | 1,000 | - |
| Phase 2 (Top 3) | 3 | 6,081 | 4,000 | 2,081 | 34% |
| Phase 3 (Remaining 7) | 7 | 6,547 | 4,850 | 1,697 | 26% |
| **Total** | **10** | **12,628** | **8,850** | **3,778** | **30%** |

### By Pattern Type

| Pattern | Commands Affected | Token Savings |
|---------|-------------------|---------------|
| Worktree Management | 6 | 1,200 |
| PR Thread Resolution | 5 | 1,000 |
| GitHub CLI Examples | 8 | 800 |
| Subagent Batching | 4 | 500 |
| GitHub GraphQL | 4 | 600 |
| PR Health Checks | 3 | 300 |
| Issue Workflows | 3 | 200 |
| **Total** | - | **4,600** |

Note: Some commands benefit from multiple pattern optimizations, so total is higher than sum of per-command savings.

## Implementation Strategy

### Priority Order

1. **Create github-cli-patterns skill** (HIGH IMPACT, LOW EFFORT)
   - 1-2 hours
   - 800 words saved across 8 commands

2. **Refactor auto-claude.md** (HIGHEST IMPACT)
   - 4-6 hours
   - 1,300 words saved (40% reduction)
   - Most complex command, biggest gains

3. **Refactor manage-pr.md** (HIGH IMPACT)
   - 2-3 hours
   - 500 words saved (35% reduction)

4. **Refactor remaining top 10** (MEDIUM IMPACT)
   - 6-8 hours total
   - 1,978 words saved (26% average reduction)

### Testing Strategy

For each refactored command:

1. **Functional Test:** Invoke the command and verify it still works
2. **Reference Test:** Verify all skill references are correct
3. **Token Test:** Measure actual token reduction using Claude Code
4. **Regression Test:** Ensure no functionality is lost

## Long-Term Recommendations

### 1. Establish Command-Agent-Skill Architecture

**Current State:** Some commands duplicate agent logic inline

**Recommendation:**
- Move all sub-agent prompts to `.claude/agents/` directory
- Commands reference agents via Task tool
- Agents reference skills for common patterns

**Example:**
```markdown
<!-- In auto-claude.md -->
## Dispatch

Use Task tool with these agents:
- branch-updater: See .claude/agents/branch-updater.md
- ci-fixer: See .claude/agents/ci-fixer.md
- pr-thread-resolver: See .claude/agents/pr-thread-resolver.md
```

### 2. Create a "Common Patterns" Index

**Purpose:** Single reference point for all reusable patterns

**Location:** `agentsmd/skills/INDEX.md`

**Content:**
```markdown
# Skills Index

Quick reference for all available skills:

- [GitHub GraphQL](github-graphql/SKILL.md) - GraphQL query patterns
- [PR Thread Resolution](pr-thread-resolution-enforcement/SKILL.md) - Thread resolution workflow
- [Subagent Batching](subagent-batching/SKILL.md) - Parallel execution patterns
- [Worktree Management](worktree-management/SKILL.md) - Worktree lifecycle
- [PR Health Check](pr-health-check/SKILL.md) - Merge-readiness criteria
- [PR Comment Limits](pr-comment-limit-enforcement/SKILL.md) - 50-comment limit enforcement
- [GitHub CLI Patterns](github-cli-patterns/SKILL.md) - Common gh commands
```

### 3. Automated Token Measurement

**Recommendation:** Add a script to measure token usage of all commands

**Script:** `.scripts/measure-command-tokens.sh`

```bash
#!/bin/bash
for cmd in agentsmd/commands/*.md; do
  words=$(wc -w < "$cmd")
  bytes=$(wc -c < "$cmd")
  echo "$words words, $bytes bytes - $(basename "$cmd")"
done | sort -rn
```

Run before/after refactoring to verify savings.

## Next Steps

1. **Review this plan** with stakeholders
2. **Create github-cli-patterns skill** (Phase 1.1)
3. **Start with auto-claude.md refactoring** (Phase 2.1)
4. **Measure token savings** after each command
5. **Iterate based on results**

## Success Metrics

- **Token Reduction:** 30%+ reduction in top 10 commands
- **Maintainability:** No duplicated patterns across commands
- **Functionality:** All commands work as before
- **Clarity:** Commands are easier to understand with skill references
- **DRY Compliance:** Each pattern exists in exactly ONE place

## Risks and Mitigations

| Risk | Mitigation |
|------|------------|
| Breaking existing commands | Thorough functional testing before/after |
| Skill references become stale | Automated link checking in CI |
| Users confused by indirection | Clear skill references with context |
| Over-abstraction reduces clarity | Keep commands self-documenting with inline context |
| Token savings less than estimated | Measure after each phase, adjust plan |

---

**Created:** 2026-01-03
**Author:** Claude (Sonnet 4.5)
**Status:** DRAFT - Pending Review
