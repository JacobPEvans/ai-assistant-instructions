# PR #29 Review: Simplify AI Instructions

**Reviewer:** Claude
**Date:** 2025-11-23
**PR:** <https://github.com/JacobPEvans/ai-assistant-instructions/pull/29>

## Executive Summary

PR #29 successfully streamlines AI instructions by removing ~314 lines of verbose content while preserving core workflows and standards. The simplification is **generally sound**, and a subsequent restoration commit has already addressed most concerns. However, reviewers identified 5 specific gaps that warrant consideration.

**Recommendation:** APPROVE with minor suggested enhancements (optional).

---

## Analysis of Reviewer Feedback

### 1. Pre-commit Validation Reminders ✅ ALREADY RESTORED

**Status:** Fully addressed in commit `5fc5b40`

The `commit.md` file now includes comprehensive pre-commit validation (lines 17-26):
- Code formatting checks
- **REQUIRED** markdown linting
- ESLint/prettier
- Terraform validation
- Security scanning

**Verdict:** No action needed.

---

### 2. "Review, Don't Chat" Principle ⚠️ DOES NOT EXIST

**Status:** Not found in git history

I searched the entire git history and found no evidence of a "Review, Don't Chat" principle. This appears to be:
- A misunderstanding by the reviewer, OR
- A concept from external documentation

The current workflow already enforces plan-driven development through the locked PRD in Step 2 (`.ai-instructions/workflows/2-plan-and-document.md`):
> "This PRD is now **locked**. It cannot be changed."

**Verdict:** Already covered by existing workflow structure. No restoration possible.

---

### 3. Research Phase Activity Checklist ⚠️ PARTIALLY VALID

**Current State:** `1-research-and-explore.md` contains only:
- Goal statement
- "Read Only" rule

**What Was Removed:** Detailed 4-step activity guide with AI prompts:
1. Analyze the Request (with prompt templates)
2. Explore the Codebase (with memory bank prompts)
3. Identify Risks and Dependencies
4. Confirm Understanding

**Assessment:**
- The verbose prompts were appropriately removed (modern AI handles this)
- **However**, a concise activity checklist would be valuable as a reminder

**Suggested Addition (optional):**

```markdown
## Key Activities

- Analyze the request and identify goals
- Explore relevant codebase areas
- Identify risks, dependencies, and unknowns
- Clarify ambiguities before proceeding to Step 2
```

**Verdict:** Minor enhancement recommended (20-30 words max).

---

### 4. Python Best Practices ✅ SHOULD RESTORE

**Current State:** Minimal Python guidance in two locations:
- `styleguide.md:53-57`: PEP 8, type hints, list comprehensions
- `generate-code.md:20-22`: PEP 8, type hints, docstrings

**What Was Removed from generate-code.md:**
- "Use virtual environments and pin dependencies in `requirements.txt`"

**Assessment:** This is **valuable, project-agnostic advice** that prevents common Python pitfalls. It's concise (12 words) and actionable.

**Verdict:** RESTORE this line to `generate-code.md:22`.

---

### 5. Line-Wrapping Guidance (MD013) ⚠️ PARTIALLY ADDRESSED

**Current State:** `review-docs.md` contains:
- Line 29: "MD013: Maximum line length is 160 characters (NOT 80)"
- Line 71: "All broken or incomplete sentences around 80-character boundaries MUST be fixed"

**Assessment:** The guidance exists but could be clearer. The "80-character boundaries" reference is confusing since the limit is 160.

**Suggested Clarification (optional):**

```markdown
**MD013 Line Length Fixes:**
- Maximum line length is 160 characters
- When fixing violations, preserve sentence integrity
- Never break words mid-character or split natural phrases awkwardly
```

**Verdict:** Current guidance is functional but could be improved for clarity.

---

## Removed Content Analysis

### Appropriately Removed ✅

1. **Verbose tutorials** - Modern AI handles basic git/file operations
2. **Adversarial testing concept** - Modern AI can self-critique
3. **Detailed prompt templates** - AI no longer needs hand-holding
4. **AI role philosophy** - Unnecessary context

### Already Restored ✅

Commit `5fc5b40` restored 65 lines of critical content:
- Pre-commit validation steps
- Prerequisites and timing guidance for PRs
- Feedback guidelines for code review
- "Before You Start" section for code generation

---

## Recommendations

### Required Actions: NONE

The PR is ready to merge as-is. All critical functionality is preserved.

### Optional Enhancements

If you want to address reviewer feedback more explicitly:

1. **Add to `1-research-and-explore.md`** (after line 8):

```markdown
## Key Activities

- Analyze the request and identify goals
- Explore relevant codebase areas
- Identify risks, dependencies, and unknowns
- Clarify ambiguities before proceeding to Step 2
```

2. **Restore to `generate-code.md`** (line 22):

```markdown
- **Python**:
  - Follow PEP 8 style guidelines.
  - Use type hints and docstrings.
  - Use virtual environments and pin dependencies in `requirements.txt`.
```

3. **Clarify in `review-docs.md`** (replace lines 29-32):

```markdown
3. **Markdownlint Standards (CRITICAL)**:
    * **MD013**: Maximum line length is 160 characters
      - Preserve sentence integrity when fixing violations
      - Never break words mid-character or split natural phrases
    * All other markdownlint rules must pass
    * Fix existing violations before creating pull requests
```

---

## Conclusion

**Overall Assessment:** The simplification achieved its goal of modernizing the instructions for current AI capabilities. The restoration commit balanced conciseness with necessary guidance.

**Verdict:** APPROVE

The suggested enhancements are **optional**. The current state is functional and maintains all essential workflows.

---

## Diff Summary

**Original Simplification (bccdde3):**
- Removed: 314 lines across 12 files
- Preserved: All standards, conventions, and workflow structure

**Restoration (5fc5b40):**
- Added back: 65 lines of critical operational guidance
- Files modified: INSTRUCTIONS.md, commit.md, generate-code.md, pull-request.md, review-code.md

**Net Change:** ~250 lines removed while maintaining functionality
