# AI Sub-Agents

## What Are Sub-Agents?

Sub-agents are specialized AI assistants designed to handle specific types of tasks with focused expertise. Each sub-agent has:

- **Dedicated context window**: Separate from the main conversation
- **Specific tool permissions**: Limited to what's needed for their task
- **Specialized system prompt**: Tailored instructions for their domain
- **Expertise focus**: Deep knowledge in a particular area

## Why Use Sub-Agents?

### Benefits

- **Expertise**: Each agent is optimized for a specific task domain
- **Context isolation**: Complex operations don't clutter the main thread
- **Parallel processing**: Multiple agents can work simultaneously on independent tasks
- **Reusability**: Consistent approach across similar tasks
- **Efficiency**: Faster task completion through specialization

### When to Use

Use sub-agents when you need:

- Specialized expertise (code review, documentation, infrastructure)
- Parallel task execution (multiple independent changes)
- Consistent approach (standardized reviews, generation patterns)
- Context isolation (complex multi-step processes)

## Available Sub-Agents

### Code Review Specialist

**File**: `code-reviewer.md`

**Expertise**:

- Security vulnerability detection
- Code quality assessment
- Standards compliance verification
- Best practices enforcement

**Use Cases**:

- Pull request reviews
- Pre-commit code checks
- Security audits
- Architecture reviews

### Documentation Review Specialist

**File**: `doc-reviewer.md`

**Expertise**:

- Markdown validation and linting
- Technical writing quality
- Documentation structure
- Cross-reference verification

**Use Cases**:

- Documentation pull requests
- Markdown file validation
- Style guide enforcement
- Link checking

### Infrastructure Review Specialist

**File**: `infrastructure-reviewer.md`

**Expertise**:

- Terraform/Terragrunt best practices
- Cloud security and compliance
- Cost optimization
- Infrastructure reliability

**Use Cases**:

- Infrastructure code reviews
- Security audits
- Cost optimization analysis
- Compliance verification

### Code Generation Specialist

**File**: `code-generator.md`

**Expertise**:

- Project scaffolding
- Pattern implementation
- Technology-specific conventions
- Test generation

**Use Cases**:

- New feature creation
- Component generation
- Boilerplate code
- Test file creation

## How to Use Sub-Agents

### In Claude Code

Sub-agents are automatically available in Claude Code when this repository structure is present:

```bash
# Project-level sub-agents (preferred)
.claude/agents/

# User-level sub-agents (global)
~/.claude/agents/
```

### Invoking Sub-Agents

#### Automatic Invocation

Claude Code automatically selects appropriate sub-agents based on your task:

```text
User: "Review this pull request for security issues"
→ Claude automatically uses Code Review Specialist
```

#### Explicit Invocation

You can explicitly request a specific sub-agent:

```text
User: "@code-reviewer please review src/auth.js focusing on authentication"
```

#### Parallel Invocation

Multiple sub-agents can work simultaneously:

```text
User: "Review this PR - use @code-reviewer for code and @doc-reviewer for docs"
→ Both agents work in parallel on their respective areas
```

### Managing Sub-Agents

Use the `/agents` slash command in Claude Code:

```text
/agents
→ Opens interface to create, edit, or delete sub-agents
```

## Sub-Agent Structure

Each sub-agent file follows this format:

```markdown
---
title: "Agent Name"
description: "Brief description of agent's purpose"
type: "sub-agent"
version: "1.0.0"
tools: ["Read", "Write", "Bash(git:*)"]
think: true
---

# Agent Name

## Purpose
What this agent specializes in

## Expertise Areas
Specific domains of knowledge

## Approach
How this agent works

## Context Requirements
What information the agent needs

## Output Format
How the agent structures responses
```

## Best Practices

### Creating Sub-Agents

1. **Single Responsibility**: Each agent should have one clear focus
2. **Minimal Tools**: Grant only necessary permissions
3. **Clear Instructions**: Provide explicit guidance on approach
4. **Example Outputs**: Show expected response formats
5. **Context Requirements**: Document what information the agent needs

### Using Sub-Agents

1. **Choose Wisely**: Select the most appropriate agent for the task
2. **Provide Context**: Give the agent necessary background information
3. **Parallel When Possible**: Use multiple agents for independent tasks
4. **Review Results**: Verify sub-agent output before finalizing
5. **Iterate**: Refine agent prompts based on performance

### Maintaining Sub-Agents

1. **Version Control**: Track changes to agent definitions
2. **Document Updates**: Record why agents were modified
3. **Test Changes**: Verify agents still work as expected
4. **Share Learnings**: Update agents with new best practices
5. **Remove Redundancy**: Consolidate overlapping agents

## Integration with Commands

Sub-agents work alongside slash commands:

| Command | Related Sub-Agent |
| ------- | ----------------- |
| `/review-code` | Code Review Specialist |
| `/review-docs` | Documentation Review Specialist |
| `/infrastructure-review` | Infrastructure Review Specialist |
| `/generate-code` | Code Generation Specialist |

Commands provide the workflow, sub-agents provide the specialized execution.

## Differences: Commands vs Sub-Agents

### Slash Commands

- **Purpose**: Workflow automation and prompt templating
- **Scope**: Define what to do and when
- **Context**: Share main conversation context
- **Use Case**: Repeatable processes and scripts

### Sub-Agents

- **Purpose**: Specialized task execution
- **Scope**: Define how to do it with expertise
- **Context**: Isolated context window
- **Use Case**: Domain-specific work requiring deep knowledge

### When to Use What

- **Use Commands** for: Automation, workflows, process standardization
- **Use Sub-Agents** for: Specialized reviews, expert analysis, domain-specific tasks
- **Use Both** for: Complete workflows with specialized steps

## Resources

- [Claude Code Sub-Agents Documentation](https://code.claude.com/docs/en/sub-agents)
- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Project Commands](../commands/)
- [Project Concepts](../concepts/)

## Contributing

To add a new sub-agent:

1. Create markdown file in `.ai-instructions/agents/`
2. Follow the standard structure (see above)
3. Create symlink in `.claude/agents/`
4. Test the sub-agent with sample tasks
5. Document in this README
6. Submit pull request

## Feedback

If you find issues or have suggestions for sub-agents:

- Open an issue describing the problem or enhancement
- Include examples of where the agent succeeded or failed
- Suggest specific prompt improvements
- Share your use cases
