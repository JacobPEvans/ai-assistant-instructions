# Step 1: Research and Explore

**Goal**: Understand the task completely before starting any work. This phase is about gathering information, defining the scope, and identifying potential challenges.

## Interaction Model

See [User Presence Modes](../concepts/user-presence-modes.md) for full details.

| Mode | Clarifying Questions | Transition to Planning |
|------|---------------------|----------------------|
| attended | Allowed at session START only | User executes `/research-complete` |
| semi-attended | Not allowed | Auto after completion |
| unattended | Not allowed | Auto after completion |

**Important:** Clarifying questions are ONLY allowed at the very beginning of a session in attended mode. Once research activities begin, resolve all ambiguity autonomously.

## Rules

- **Do Not Change Files**: You must not change or delete any files in this step.
- **Read Only**: This step is for reading and learning only.

## Key Activities

### 1. Initial Clarification (Attended Mode Only)

If in `attended` mode and requirements are ambiguous:

1.1. Ask **brief, specific** clarifying questions at the session START
1.2. Limit to 3-5 essential questions maximum
1.3. Once answers received, proceed autonomously
1.4. **Do NOT** ask follow-up questions mid-research

### 2. Analyze the Request

2.1. Read the user's request or prompt file carefully.
2.2. Identify the main goal, the "start state," and the desired "end state."
2.3. **Prompt**: "My goal is to [describe the feature or fix]. What is the best way to approach this, keeping our [tech stack and patterns] in mind?"

### 3. Explore the Codebase

3.1. Use file system and search tools to find relevant files, functions, and components.
3.2. Read the contents of the files to understand the existing code style, patterns, and libraries.
3.3. **Prompt**: "I need to implement [feature]. Based on the `memory-bank`, what are the key files I need to modify?"

### 4. Identify Risks and Dependencies

4.1. Analyze the potential impact of the changes.
4.2. **Prompt**: "What are the potential risks or side effects of modifying these files? Are there any dependencies I should be aware of?"

### 5. Resolve Remaining Ambiguity Autonomously

5.1. Apply [Self-Healing](../concepts/self-healing.md) resolution strategies for any remaining unclear items.
5.2. Document all assumptions in `active-context.md` with confidence scores.
5.3. Proceed to Step 2 with best-effort understanding.

## Phase Completion

### Attended Mode
- User executes `/research-complete` to transition to Planning
- AI presents findings and initiates PRD discussion

### Semi-Attended / Unattended Mode
- Auto-transition when research activities complete
- Generate PRD autonomously
