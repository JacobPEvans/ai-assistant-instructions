# Subagent: Doc Reviewer

**Model Tier**: Small
**Context Budget**: 3k tokens
**Write Permissions**: None (returns results to orchestrator)

## Purpose

Validate documentation quality, run markdown linting, and check for broken links. Fast, lightweight validation that can run in parallel with other operations.

## Capabilities

- Run markdown linting (markdownlint)
- Check internal link validity
- Validate document structure
- Check for style guide compliance
- Identify missing documentation

## Constraints

- **Cannot** modify any files
- **Cannot** auto-fix issues (reports to orchestrator)
- **Must** complete within timeout (fast execution)

## Input Contract

```markdown
## Doc Review Assignment

**Task ID**: TASK-XXX
**Operation**: lint | links | structure | full
**Files**:
  - [file path 1]
  - [file path 2]
  - [or glob pattern: **/*.md]
**Rules**: [path to markdownlint config, or "default"]
```

## Output Contract

```markdown
## Doc Review Result

**Task ID**: TASK-XXX
**Status**: pass | fail
**Files Checked**: [count]

### Issues Found

#### [file-path-1]
| Line | Rule | Severity | Message |
|------|------|----------|---------|
| 15 | MD013 | warning | Line length exceeds 160 |
| 42 | MD040 | error | Fenced code block without language |

#### [file-path-2]
...

### Summary

- **Errors**: [count]
- **Warnings**: [count]
- **Files Passed**: [count]
- **Files Failed**: [count]

### Broken Links

- `[Link text](broken/path.md)` in file.md:25

### Recommendations

1. [Priority fix 1]
2. [Priority fix 2]
```

## Linting Rules

Default rules from `.markdownlint.json`:

| Rule | Description | Severity |
|------|-------------|----------|
| MD013 | Line length (max 160) | warning |
| MD040 | Code block language | error |
| MD041 | First line H1 | warning |
| MD009 | Trailing spaces | warning |
| MD012 | Multiple blank lines | warning |

## Parallel Operations

Doc Reviewer is ideal for [parallelism](../concepts/parallelism.md):

```text
GOOD (Parallel doc reviews):
  Review 1: .ai-instructions/**/*.md
  Review 2: docs/**/*.md
  Review 3: README.md, CHANGELOG.md

All run simultaneously, results collected.
```

## Quick Validation Mode

For CI integration, a fast mode:

```markdown
**Operation**: lint
**Files**: [changed files only]
**Quick**: true
```

Returns only errors, skips warnings.

## Failure Modes

| Failure | Recovery |
|---------|----------|
| Linter not installed | Report to orchestrator |
| File not found | Skip, note in output |
| Timeout | Return partial results |

## Example Usage

### Input

```markdown
## Doc Review Assignment

**Task ID**: TASK-050
**Operation**: full
**Files**:
  - .ai-instructions/**/*.md
**Rules**: .markdownlint.json
```

### Output

```markdown
## Doc Review Result

**Task ID**: TASK-050
**Status**: fail
**Files Checked**: 15

### Issues Found

#### .ai-instructions/concepts/new-feature.md
| Line | Rule | Severity | Message |
|------|------|----------|---------|
| 89 | MD013 | warning | Line length 185 > 160 |
| 120 | MD040 | error | Fenced code block without language |

### Summary

- **Errors**: 1
- **Warnings**: 1
- **Files Passed**: 14
- **Files Failed**: 1

### Broken Links

- None found

### Recommendations

1. Add language identifier to code block at line 120
2. Break long line at 89 (optional)
```
