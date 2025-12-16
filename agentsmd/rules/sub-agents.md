# Concept: AI Sub-Agents

## What Are Sub-Agents?

Sub-agents are specialized AI assistants that handle specific types of tasks with focused expertise.
Unlike general-purpose AI interactions, sub-agents are purpose-built for particular domains like code
review, documentation, or infrastructure management.

## Core Characteristics

### Isolation

Each sub-agent operates with its own context window, separate from the main conversation.
This prevents complex operations from cluttering your primary thread and allows for parallel processing.

### Specialization

Sub-agents have tailored system prompts that make them experts in specific areas:

- Code review with security focus
- Documentation quality and markdown validation
- Infrastructure as Code best practices
- Code generation following patterns

### Tool Permissions

Each sub-agent is granted only the tools necessary for its task, following the principle of least privilege:

```yaml
# Example: Code reviewer only needs read access
tools: ["Read", "Grep", "Glob", "Bash(git:*)"]

# Example: Code generator needs write access
tools: ["Read", "Write", "Bash(npm:*)", "Bash(pip:*)"]
```

## Differences: Commands vs Sub-Agents

### Slash Commands

**Purpose**: Workflow automation and prompt templating

- Define **what** to do and **when**
- Share main conversation context
- Execute scripted processes
- Provide consistent workflows

**Example**: `/commit` runs through a standardized commit checklist

### Sub-Agents

**Purpose**: Specialized task execution

- Define **how** to do it with expertise
- Isolated context window
- Apply domain-specific knowledge
- Handle complex analysis

**Example**: `@code-reviewer` analyzes code with security expertise

### Working Together

Commands and sub-agents complement each other:

```text
User: /review-code src/auth.js
→ Command defines the workflow
  → Sub-agent @code-reviewer executes with expertise
    → Analyzes security patterns
    → Checks best practices
    → Provides structured feedback
```

## When to Use Sub-Agents

### Ideal Use Cases

1. **Specialized Review Tasks**
   - Code reviews requiring deep analysis
   - Documentation quality checks
   - Infrastructure security audits

2. **Parallel Processing**
   - Multiple independent changes
   - Different files or modules
   - Non-overlapping tasks

3. **Complex Generation**
   - Scaffolding new features
   - Implementing design patterns
   - Creating comprehensive tests

4. **Consistent Expertise**
   - Applying standards uniformly
   - Following organizational patterns
   - Maintaining quality gates

### When NOT to Use

1. **Simple Tasks**: Basic file edits don't need sub-agents
2. **Exploratory Work**: Initial research benefits from general context
3. **Sequential Dependencies**: Tasks requiring previous context
4. **Quick Questions**: Direct queries are faster

## Sub-Agent Structure

Standard sub-agent format:

```markdown
---
title: "Agent Name"
description: "Brief agent purpose"
type: "sub-agent"
version: "1.0.0"
tools: ["Read", "Write"]  # Minimal necessary tools
think: true                # Enable reasoning
---

# Agent Name

## Purpose
Clear statement of what this agent does

## Expertise Areas
Specific domains of knowledge

## Approach
Step-by-step process the agent follows

## Context Requirements
Information the agent needs to work effectively

## Output Format
Expected structure of responses
```

## Directory Structure

Following the DRY principle, sub-agents are stored centrally:

```text
.ai-instructions/
  agents/
    README.md
    code-reviewer.md
    doc-reviewer.md
    infrastructure-reviewer.md
    code-generator.md

.claude/
  agents/               # Symlinks to .ai-instructions/agents/
    code-reviewer.md -> ../../.ai-instructions/agents/code-reviewer.md
    doc-reviewer.md -> ../../.ai-instructions/agents/doc-reviewer.md
    # ... etc
```

This structure:

- Maintains single source of truth
- Enables version control
- Supports multiple AI tools
- Simplifies maintenance

## Best Practices

### Creating Sub-Agents

1. **Single Responsibility**
   - Focus on one domain
   - Clear expertise boundaries
   - Avoid feature creep

2. **Minimal Permissions**
   - Grant only necessary tools
   - Follow least privilege principle
   - Document tool requirements

3. **Clear Instructions**
   - Explicit step-by-step approach
   - Example outputs
   - Context requirements

4. **Versioning**
   - Track changes to agent behavior
   - Document improvements
   - Maintain compatibility

### Using Sub-Agents

1. **Choose Appropriately**
   - Match agent to task complexity
   - Use general AI for exploration
   - Use sub-agents for specialized work

2. **Provide Context**
   - Share relevant background
   - Specify constraints
   - Clarify expectations

3. **Parallel When Possible**
   - Identify independent tasks
   - Launch multiple agents
   - Merge results efficiently

4. **Review Output**
   - Validate recommendations
   - Apply critical thinking
   - Iterate as needed

## Integration with Workflows

Sub-agents fit into the 5-step development workflow:

### Step 1: Research and Explore

Use general AI, not sub-agents. This phase needs breadth, not specialized depth.

### Step 2: Plan and Document

- Use `@doc-reviewer` to validate planning documents
- Ensure markdown quality early

### Step 3: Define Success and Create PR

- Use `@code-generator` to create test scaffolding
- Generate test cases with patterns

### Step 4: Implement and Verify

- Use `@code-generator` for implementation
- Use `@code-reviewer` for self-review before PR
- Use `@infrastructure-reviewer` for IaC changes

### Step 5: Finalize and Commit

- Use `@doc-reviewer` for final documentation check
- Use `@code-reviewer` for pre-commit validation

## Available Sub-Agents

### Code Review Specialist

**Focus**: Security, quality, standards

**When to use**:

- Pull request reviews
- Pre-commit validation
- Security audits

### Documentation Review Specialist

**Focus**: Markdown quality, technical writing

**When to use**:

- Documentation PRs
- Pre-commit doc checks
- Link validation

### Infrastructure Review Specialist

**Focus**: Terraform/Terragrunt, cloud security, costs

**When to use**:

- Infrastructure code reviews
- Security compliance checks
- Cost optimization analysis

### Code Generation Specialist

**Focus**: Scaffolding, patterns, best practices

**When to use**:

- New feature creation
- Component generation
- Test file creation

## Extending the System

To add new sub-agents:

1. Identify a specialized need
2. Define expertise boundaries
3. Create agent file in `.ai-instructions/agents/`
4. Create symlink in `.claude/agents/`
5. Test with sample tasks
6. Document in agents README
7. Update this concept document

## Resources

- [Sub-Agents Directory](../agents/): Available sub-agents
- [Commands Directory](../commands/): Workflow commands
- [Claude Sub-Agents Docs](https://code.claude.com/docs/en/sub-agents): Official documentation
- [DRY Principle](./dry-principle.md): Why we use symlinks

## Memory Bank Integration

When a sub-agent discovers patterns or conventions:

- Store in relevant Memory Bank document
- Reference from sub-agent definition
- Keep knowledge centralized
- Update as patterns evolve

See [Memory Bank](./memory-bank/README.md) for details.
