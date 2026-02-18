# Authoring Standards

Context tokens are limited. Follow these principles when authoring agentsmd files.

## Token Conservation

### File Authoring

- Target 500 tokens per file (1,000 max)
- CLAUDE.md additions: bare minimum—link to rules/skills for details
- Single-purpose design: each skill/agent/rule does one thing

### DRY Principle

Define once, reference everywhere. Never duplicate patterns, thresholds, or explanations across files.

### Loading Strategy

Skills and agents load on-demand when invoked. Keep startup footprint minimal.

## Best Practices

**Frontmatter** (required, varies by type):

- **Skills**:

  ```yaml
  ---
  name: skill-name
  description: Pattern description
  ---
  ```

- **Agents**:

  ```yaml
  ---
  name: agent-name
  description: Action-focused description
  model: haiku  # or sonnet/opus
  author: JacobPEvans
  allowed-tools: [list of tools]
  ---
  ```

**Naming**: Skills use `noun-pattern`, agents use `noun-doer`.

## Cross-Referencing

**Within agents, skills, and rules**: Reference by name only (e.g., "the code-standards rule").
Rules in `.claude/rules/` auto-load every session. Other files load on demand when referenced.

**In CLAUDE.md files**: Use `@path/to/file` to compose content inline. Reserve markdown links for
conditional "see X if relevant" references where you do NOT want content auto-loaded.
