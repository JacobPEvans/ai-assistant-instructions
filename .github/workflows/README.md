# GitHub Actions Workflows

## Merge Gatekeeper Pattern

This repository uses the **Merge Gatekeeper Pattern** for CI validation on pull requests.

### Problem Solved

GitHub branch protection only supports "always required" or "not required" status checks.
Path-filtered workflows that don't run result in pending status forever, blocking merges.

### Solution

A single `ci-gate.yml` workflow that:

1. **Always triggers** on ALL PRs (no path filters at workflow level)
2. **Detects** which file categories changed using `dorny/paths-filter`
3. **Calls** reusable workflows conditionally (skipped jobs = success)
4. **Aggregates** results into a single "Merge Gate" check via `re-actors/alls-green`

### Branch Protection Setup

Set **only** "Merge Gate" as the required status check:

```text
Settings → Rules → Rulesets → main
  → Require status checks to pass
  → Add: "Merge Gate"
```

## PR Check Names

These are the check names that appear in GitHub PR status:

| Check Name | Description |
|------------|-------------|
| CI Gate / Detect Changes | Identifies which file categories changed |
| CI Gate / Claude Code Lint | Validates Claude Code configuration |
| CI Gate / Schema Validation | Validates cclint schema and permissions |
| CI Gate / Markdown Lint | Checks markdown formatting |
| CI Gate / Spell Check | Checks spelling in markdown files |
| CI Gate / Token Limit Check | Enforces token usage limits |
| CI Gate / Instruction Validation | Validates required instruction files |
| CI Gate / YAML Lint | Validates YAML syntax |
| CI Gate / Merge Gate | Aggregates all check results (REQUIRED) |

## Path Filter Categories

| Category | Files | Triggers |
|----------|-------|----------|
| `claude-config` | `.claude/**`, `CLAUDE.md`, `.cclintrc.jsonc` | Claude Code Lint, Schema Validation, Token Limit Check |
| `agentsmd` | `agentsmd/**` | Claude Code Lint, Instruction Validation, Token Limit Check |
| `permissions` | `agentsmd/permissions/**`, `scripts/validate-permissions.sh` | Schema Validation |
| `markdown` | `**/*.md`, `.markdownlint-cli2.jsonc`, `.cspell.json` | Markdown Lint, Spell Check, Token Limit Check |
| `yaml` | `**/*.yml`, `**/*.yaml`, `.yamllint.yml` | YAML Lint |
| `workflows` | `.github/workflows/**` | YAML Lint |

## Workflow Architecture

```text
┌─────────────────────────────────────────────────────────────┐
│                    REUSABLE WORKFLOWS                       │
│         (Implementation - triggered via workflow_call)       │
├─────────────────────────────────────────────────────────────┤
│  _cclint.yml              │ Claude Code Lint                │
│  _markdownlint.yml        │ Markdown Lint                   │
│  _spellcheck.yml          │ Spell Check                     │
│  _token-limits.yml        │ Token Limit Check               │
│  _validate-cclint.yml     │ Schema Validation               │
│  _validate-instructions.yml │ Instruction Validation        │
│  _yaml-lint.yml           │ YAML Lint                       │
└─────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┴───────────────┐
              ▼                               ▼
┌─────────────────────────┐     ┌─────────────────────────┐
│      ci-gate.yml        │     │   Push-to-Main Wrappers │
│   (PR orchestrator)     │     │                         │
├─────────────────────────┤     ├─────────────────────────┤
│ • Detects file changes  │     │ cclint.yml              │
│ • Calls reusable flows  │     │ markdownlint.yml        │
│ • Merge Gate aggregates │     │ spellcheck.yml          │
│ • ONLY required check   │     │ token-limits.yml        │
└─────────────────────────┘     │ validate-cclint-schema  │
                                │ validate-instructions   │
                                │ yaml-lint.yml           │
                                └─────────────────────────┘
```

## Adding New Checks

1. Create reusable workflow: `_your-check.yml` with `on: workflow_call`
2. Add filter pattern under `changes.steps.filter.with.filters` in `ci-gate.yml`
3. Add job that calls the reusable workflow with appropriate `if:` condition
4. Add job name to `gate.needs` array and `allowed-skips`
5. Create push-to-main wrapper: `your-check.yml` calling the reusable workflow

## Special Handling

### Renovate Dependency PRs

PRs from `app/renovate` with titles starting with `chore(deps)` skip expensive checks
like `token-limits` to speed up dependency update merges.

### Workflows Not in Merge Gate

These workflows run independently and are not part of the Merge Gate:

- `pr-comment-limit-check.yml` - Enforces 50-comment limit on PRs
- `issue-resolver.yml` - Auto-labels GitHub issues
- `link-check.yml` - Validates links (push to main only)
- `sync-symlinks.yml` - Syncs command symlinks (push to main only)
- `label-sync.yml` - Syncs GitHub labels (push to main only)

## Concurrency Control

The CI Gate uses concurrency groups to cancel in-progress runs when new commits are pushed:

```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.event.pull_request.number || github.ref }}
  cancel-in-progress: true
```
