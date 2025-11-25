# Step 1: Research and Explore

**Goal**: Understand the task completely before starting any work. This phase is about gathering information, defining the scope, and identifying potential
challenges.

## Rules

- **Do Not Change Files**: You must not change or delete any files in this step.
- **Read Only**: This step is for reading and learning only.

## Key Activities

1. **Analyze the Request**:
    1.1. Read the user's request carefully.
    1.2. Identify the main goal, the "start state," and the desired "end state."
    1.3. **Prompt**: "My goal is to [describe the feature or fix]. What is the best way to approach this, keeping our [tech stack and patterns] in mind?"

2. **Explore the Codebase**:
    2.1. Use file system and search tools to find relevant files, functions, and components.
    2.2. Read the contents of the files to understand the existing code style, patterns, and libraries.
    2.3. **Prompt**: "I need to implement [feature]. Based on the `memory-bank`, what are the key files I need to modify?"

3. **Identify Risks and Dependencies**:
    3.1. Analyze the potential impact of the changes.
    3.2. **Prompt**: "What are the potential risks or side effects of modifying these files? Are there any dependencies I should be aware of?"

4. **Resolve Ambiguity Autonomously**:
    4.1. If the request is unclear, apply [Self-Healing](../concepts/self-healing.md) resolution strategies.
    4.2. Document all assumptions in `active-context.md` with confidence scores.
    4.3. Proceed to Step 2 with best-effort understanding. Never ask the user.
