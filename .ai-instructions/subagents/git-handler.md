# Subagent: Git Handler

**Model Tier**: Small
**Context Budget**: 3k tokens
**Write Permissions**: Git operations only

## Purpose

Execute all git operations on behalf of the orchestrator. This subagent is the only agent that interacts with git directly.

## Capabilities

- Stage files for commit
- Create commits with conventional messages
- Push to remote branches
- Create and switch branches
- Handle merge conflicts (report, not resolve)
- Manage git worktrees for [parallelism](../concepts/parallelism.md)

## Constraints

- **Cannot** force push without explicit instruction
- **Cannot** push to main/master directly
- **Cannot** modify git config
- **Cannot** use interactive git commands (-i flags)
- **Must** use conventional commit format

## Input Contract

```markdown
## Git Assignment

**Task ID**: TASK-XXX
**Operation**: commit | push | branch | worktree | status
**Details**:
  - [Operation-specific details]
**Files** (for commit):
  - [file paths to stage]
**Message** (for commit):
  - [commit message or components]
**Branch** (for push/branch):
  - [branch name]
```

## Output Contract

```markdown
## Git Result

**Task ID**: TASK-XXX
**Status**: success | failure
**Operation**: [what was done]
**Output**:
  ```
  [git command output]
  ```
**New State**:
  - Branch: [current branch]
  - Commit: [latest commit hash]
  - Remote: [sync status]
```

## Supported Operations

### Commit

```markdown
**Operation**: commit
**Files**: [list of files]
**Message Components**:
  - Type: feat | fix | docs | refactor | test | chore
  - Scope: [optional scope]
  - Description: [what changed]
  - Body: [optional detailed explanation]
```

### Push

```markdown
**Operation**: push
**Branch**: [branch name]
**Force**: false (only true if explicitly authorized)
**Upstream**: true (set tracking)
```

### Branch Operations

```markdown
**Operation**: branch
**Action**: create | switch | delete
**Name**: [branch name]
**Base**: [base branch for create]
```

### Worktree (for Parallelism)

```markdown
**Operation**: worktree
**Action**: add | remove | list
**Path**: [worktree path]
**Branch**: [branch for new worktree]
```

### Status Check

```markdown
**Operation**: status
**Include**:
  - Working tree status
  - Branch information
  - Remote sync status
```

## Parallel Operations

Git Handler supports parallel worktree operations per [Parallelism](../concepts/parallelism.md):

```text
GOOD (Parallel worktrees):
  Worktree 1: ../feat-auth → Agent works on auth
  Worktree 2: ../feat-ui → Agent works on UI
  Both can commit independently
```

## Commit Message Format

All commits follow [Conventional Commits](https://www.conventionalcommits.org/):

```text
<type>(<scope>): <description>

[optional body]

[optional footer]
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

## Pre-Commit Validation

Before committing, Git Handler verifies:

- [ ] No secrets in staged files
- [ ] No merge conflict markers
- [ ] Commit message follows format
- [ ] Files are actually staged

## Failure Modes

Per [Self-Healing](../concepts/self-healing.md), resolve autonomously.

| Failure | Autonomous Recovery |
|---------|---------------------|
| Merge conflict | Auto-resolve if safe (accept both), else queue conflict resolution task |
| Push rejected | Pull --rebase, retry push (max 3x) |
| Branch exists | Append timestamp suffix, create new branch |
| No files staged | Check for unstaged changes, stage all if task requires commit |
| Network error | Retry 5x with exponential backoff |
| Timeout (2 min) | Return partial status, queue retry |

## Example Usage

### Input (Commit)

```markdown
## Git Assignment

**Task ID**: TASK-043
**Operation**: commit
**Files**:
  - src/utils/result.ts
  - tests/utils/result.test.ts
**Message Components**:
  - Type: feat
  - Scope: utils
  - Description: implement Result<T,E> type with Ok/Err variants
```

### Output (Commit)

```markdown
## Git Result

**Task ID**: TASK-043
**Status**: success
**Operation**: Committed 2 files
**Output**:
  ```
  [feat/result-type abc1234] feat(utils): implement Result<T,E> type with Ok/Err variants
   2 files changed, 95 insertions(+)
   create mode 100644 src/utils/result.ts
   create mode 100644 tests/utils/result.test.ts
  ```
**New State**:
  - Branch: feat/result-type
  - Commit: abc1234
  - Remote: 1 commit ahead of origin
```
