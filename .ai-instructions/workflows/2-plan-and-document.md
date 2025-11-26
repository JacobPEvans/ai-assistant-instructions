# Step 2: Plan and Document (as a PRD)

**Goal:** Create a detailed Product Requirements Document (PRD) that is final for this cycle.

## Interaction Model

See [User Presence Modes](../concepts/user-presence-modes.md) for full details.

| Mode | User Collaboration | PRD Approval | Transition to Coding |
|------|-------------------|--------------|---------------------|
| attended | **Full iteration** until user satisfied | Explicit user approval | User executes `/start-implementation` |
| semi-attended | None (auto-generate) | 2 min grace period | Auto after grace period |
| unattended | None (auto-generate) | None required | Immediate |

### Attended Mode Behavior

Planning is **fully interactive** in attended mode:

1. AI proposes initial PRD structure
2. User and AI iterate back-and-forth
3. Continue until user is 100% satisfied
4. User signals completion with `/start-implementation`

**Key:** The AI should actively seek user feedback during this phase. Ask questions like:

- "Does this implementation approach align with your vision?"
- "Should I add any additional requirements?"
- "Are there edge cases we should address?"

### Semi-Attended / Unattended Mode Behavior

Planning is **autonomous**:

1. AI generates complete PRD autonomously
2. Apply [Self-Healing](../concepts/self-healing.md) for all decisions
3. Document assumptions with confidence scores
4. Auto-transition to implementation

## Rules

- **Do Not Change Project Files.** You must not change project code or documentation yet.
- **Create a PRD File.** Your only output is a new PRD file.
- **Checklist-Driven Plan**: The `Implementation Plan` must be a Markdown checklist where each item is a complete, executable prompt for the AI's next step.

## Tasks

1. **Create a Temporary PRD File.**
    1.1. Create a new file named `.tmp/prd-<task-name>.md`.
    1.2. Replace `<task-name>` with a short name for the current task.

2. **Write the PRD.** The PRD must contain the following sections:
    2.1. **Objective:** What is the high-level goal? What user problem are we solving?
    2.2. **Success Metrics:** How will we measure success? What is the expected, measurable outcome?
    2.3. **Requirements:** Use a numbered list to define the specific functional requirements. What must the solution do?
    2.4. **Out of Scope:** What are we explicitly *not* doing?
    2.5. **Implementation Plan:** A detailed, step-by-step technical plan to meet the requirements. This must be a checklist of executable prompts.
    2.6. **Risks:** What could go wrong?

3. **Cross-Examine the Plan.**
    3.1. Before finalizing the PRD, get a "second opinion" on the implementation plan.
    3.2. Follow the process outlined in the [Adversarial Testing](./../concepts/adversarial-testing.md) concept.

4. **Advanced: Parallel Tasks (Optional).**
    4.1. If the plan contains independent tasks, note this in the `Implementation Plan`.
    4.2. Suggest the use of `git worktree` to separate these tasks.

5. **Finalize the PRD.**
    5.1. Review the PRD for clarity and completeness.
    5.2. This PRD is now **locked**. It cannot be changed. If the PRD is wrong, the entire 5-step process must fail and restart from Step 1.

## Phase Completion

### Attended Mode

- Present final PRD to user for review
- User executes `/start-implementation` to lock PRD and begin coding
- **Critical:** Do not proceed until user explicitly approves

### Semi-Attended Mode

- Announce PRD completion
- Wait 2 minutes for user objection
- Auto-transition if no objection

### Unattended Mode

- Log PRD creation
- Immediately transition to implementation
