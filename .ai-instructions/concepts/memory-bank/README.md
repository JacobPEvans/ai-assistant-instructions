# Concept: The Memory Bank

The "Memory Bank" is the most critical component of the AI-first workflow. It serves as the AI's "external brain," providing a persistent, structured, and
comprehensive knowledge base about the project.

## The Golden Rule: Your Mindset is Everything

Treat the AI as a brilliant, amnesiac expert. It’s incredibly talented, but it forgets who you are and what you're doing every few minutes.
Your single most important job is to build a perfect external brain for it, allowing it to "regain its memory" and get to work at any moment.
The Memory Bank is that external brain.

## Purpose

The primary purpose of the Memory Bank is to solve the problem of context limitation and session amnesia in Large Language Models (LLMs).
By maintaining a set of focused, up-to-date documents, you provide the AI with a reliable source of truth it can consult at the beginning of any session
or task.

This enables:

- **Consistency**: The AI's work remains aligned with the project's goals, architecture, and standards.
- **Efficiency**: Reduces the need for lengthy, repetitive context-setting in every prompt.
- **Scalability**: Allows the project to grow in complexity without overwhelming the AI's context window.
- **Collaboration**: Enables seamless handoffs between different AI assistants or between an AI and a human developer.

## Core Components

The Memory Bank is a directory containing several key documents. Each document has a specific purpose and should be kept concise and up-to-date.

### Read-Only (Context)

- **[Project Brief](./project-brief.md)**: A one-sentence description of the project.
- **[Technical Context](./technical-context.md)**: The tech stack, libraries, and versions.
- **[System Patterns](./system-patterns.md)**: The architecture and design patterns.

### Read-Write (State)

- **[Active Context](./active-context.md)**: The "current memory" of what is being worked on right now.
- **[Progress Tracking](./progress-tracking.md)**: The overall project progress and what is complete.
- **[Task Queue](./task-queue.md)**: The orchestrator's input source for [autonomous operation](../autonomous-orchestration.md).

## Autonomous Operation

For fully autonomous AI operation, the Memory Bank serves as the **sole input source**:

1. Orchestrator reads `task-queue.md` for pending work
2. Orchestrator reads `active-context.md` for current state
3. Orchestrator writes updates to `progress-tracking.md`
4. Cycle repeats until task queue is empty

See [Autonomous Orchestration](../autonomous-orchestration.md) for the complete system design.
