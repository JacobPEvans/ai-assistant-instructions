# Architecture Diagrams

This document provides visual diagrams of key workflows and concepts in the AI assistant instruction system.

## System Overview

### Full Autonomous Architecture

```mermaid
graph TB
    subgraph "User Interface"
        U[User] -->|"prompt files, messages"| PM[Project Root Prompts]
        U -->|"slash commands"| SC[Slash Commands]
    end

    subgraph "Session Management"
        PM --> SM[Session Manager]
        SC --> SM
        SM -->|"set"| ENV[AI_USER_PRESENT]
        SM -->|"set"| MODE[AI_SESSION_MODE]
    end

    subgraph "Orchestrator (Large Model)"
        SM --> O[Orchestrator]
        O --> CM[Context Manager]
        O --> TM[Task Manager]
        O --> WD[Watchdog]
        ENV --> WD
    end

    subgraph "Subagents (Medium/Small Models)"
        O --> WR[Web Researcher]
        O --> CD[Coder]
        O --> TS[Tester]
        O --> GH[Git Handler]
        O --> PR[PR Resolver]
        O --> IC[Issue Creator]
        O --> IR[Issue Resolver]
        O --> CR[Commit Reviewer]
    end

    subgraph "External Systems"
        GH --> GIT[(Git)]
        PR --> GHAPI[GitHub API]
        IC --> GHAPI
        IR --> GHAPI
        WR --> WEB[Web/Docs]
    end

    subgraph "Memory Bank"
        O --> MB[(Memory Bank)]
        MB --> AC[active-context.md]
        MB --> TQ[task-queue.md]
        MB --> PT[progress-tracking.md]
    end
```

## Workflow State Machine

### 5-Step Development Workflow

```mermaid
stateDiagram-v2
    [*] --> Research: Task received

    Research --> Planning: /research-complete (attended)
    Research --> Planning: auto (unattended)

    Planning --> Implementation: /start-implementation (attended)
    Planning --> Implementation: auto (unattended)

    Implementation --> Verification: Tests pass

    Verification --> Commit: All checks pass
    Verification --> Implementation: Checks fail

    Commit --> Complete: PR merged
    Commit --> Verification: PR feedback

    Complete --> [*]: Queue empty
    Complete --> Research: Next task

    state Research {
        [*] --> Analyze
        Analyze --> Explore
        Explore --> Clarify: attended + ambiguous
        Clarify --> Explore
        Explore --> [*]
    }

    state Planning {
        [*] --> Draft_PRD
        Draft_PRD --> User_Review: attended
        Draft_PRD --> Auto_Approve: unattended
        User_Review --> Iterate
        Iterate --> User_Review
        User_Review --> Lock_PRD
        Auto_Approve --> Lock_PRD
        Lock_PRD --> [*]
    }

    state Implementation {
        [*] --> Code
        Code --> Test
        Test --> Code: fail
        Test --> [*]: pass
    }
```

## User Presence Mode Decision Tree

```mermaid
flowchart TD
    START[Session Start] --> CHECK{Mode specified?}

    CHECK -->|Yes| SET[Set AI_SESSION_MODE]
    CHECK -->|No| INFER{Infer from context}

    INFER -->|Single task| ATT[attended]
    INFER -->|Batch tasks| SEMI[semi-attended]
    INFER -->|Overnight mentioned| UN[unattended]

    ATT --> PRESENT[AI_USER_PRESENT=true]
    SEMI --> PRESENT
    UN --> ABSENT[AI_USER_PRESENT=false]

    SET --> WORK[Begin Work]
    PRESENT --> WORK
    ABSENT --> WORK

    WORK --> TIMEOUT{15 min timeout?}
    TIMEOUT -->|No| WORK
    TIMEOUT -->|Yes| PROMPT[Prompt user]

    PROMPT --> RESPONSE{User responds?}
    RESPONSE -->|Yes, within 2 min| WORK
    RESPONSE -->|No| SWITCH[Switch to unattended]
    SWITCH --> ABSENT
```

## Self-Healing Decision Flow

```mermaid
flowchart TD
    AMB[Ambiguous Instruction] --> P1{Pattern in system-patterns.md?}

    P1 -->|Yes| USE_PATTERN[Follow existing pattern]
    P1 -->|No| P2{Similar in codebase?}

    P2 -->|Yes| USE_EXISTING[Match existing style]
    P2 -->|No| P3{Industry best practice?}

    P3 -->|Yes| USE_BEST[Apply best practice]
    P3 -->|No| USE_SIMPLE[Apply simplest solution]

    USE_PATTERN --> DOC[Document assumption]
    USE_EXISTING --> DOC
    USE_BEST --> DOC
    USE_SIMPLE --> DOC

    DOC --> SCORE[Add confidence score]
    SCORE --> CONTINUE[Continue execution]
```

## Error Recovery and 5 Whys

```mermaid
flowchart TD
    FAIL[Operation Fails] --> COUNT{Consecutive failures?}

    COUNT -->|1-2| RETRY[Retry with backoff]
    COUNT -->|3+| WHYS[5 Whys Analysis]

    RETRY --> SUCCESS{Success?}
    SUCCESS -->|Yes| DONE[Continue]
    SUCCESS -->|No| COUNT

    WHYS --> ROOT[Identify root cause]
    ROOT --> OPTIONS[Generate 3 options]
    OPTIONS --> SELECT[Select resolution]
    SELECT --> IMPLEMENT[Implement fix]
    IMPLEMENT --> VERIFY{Fixed?}

    VERIFY -->|Yes| DONE
    VERIFY -->|No| NEXT{More options?}
    NEXT -->|Yes| SELECT
    NEXT -->|No| QUEUE[Queue for next session]
```

## Parallel Issue Resolution

```mermaid
flowchart TD
    subgraph Fetch["Fetch Phase"]
        F[Fetch Open Issues] --> P[Prioritize by labels]
        P --> S[Select top 5]
    end

    subgraph Setup["Worktree Setup"]
        S --> W1[Worktree 1]
        S --> W2[Worktree 2]
        S --> W3[Worktree 3]
        S --> W4[Worktree 4]
        S --> W5[Worktree 5]
    end

    subgraph Work["Parallel Work"]
        W1 --> C1[Coder: Issue 1]
        W2 --> C2[Coder: Issue 2]
        W3 --> C3[Coder: Issue 3]
        W4 --> C4[Coder: Issue 4]
        W5 --> C5[Coder: Issue 5]
    end

    subgraph PR["PR Creation"]
        C1 --> PR1[PR #1]
        C2 --> PR2[PR #2]
        C3 --> PR3[PR #3]
        C4 --> PR4[PR #4]
        C5 --> PR5[PR #5]
    end

    subgraph CI["CI/Merge"]
        PR1 --> CI1{CI Pass?}
        PR2 --> CI2{CI Pass?}
        PR3 --> CI3{CI Pass?}
        PR4 --> CI4{CI Pass?}
        PR5 --> CI5{CI Pass?}

        CI1 -->|Yes| MQ[Merge Queue]
        CI2 -->|Yes| MQ
        CI3 -->|Yes| MQ
        CI4 -->|Yes| MQ
        CI5 -->|Yes| MQ

        MQ --> AM[Auto-Merge]
        AM --> REBASE[Rebase remaining]
        REBASE --> CI1
    end
```

## Watchdog Mechanism

```mermaid
flowchart TD
    WORK[Working on Task] --> TIMER[Start 15 min timer]

    TIMER --> PROGRESS{Progress made?}

    PROGRESS -->|Yes| RESET[Reset timer]
    RESET --> WORK

    PROGRESS -->|No timeout| TIMER

    PROGRESS -->|Timeout| CHECK{AI_USER_PRESENT?}

    CHECK -->|true| PROMPT[Prompt user for guidance]
    CHECK -->|false| COMMIT[Commit checkpoint]

    PROMPT --> WAIT{Response in 2 min?}
    WAIT -->|Yes| WORK
    WAIT -->|No| SWITCH[Set AI_USER_PRESENT=false]
    SWITCH --> COMMIT

    COMMIT --> GUESS[Make best guess]
    GUESS --> DOC[Document uncertainty]
    DOC --> WORK
```

## Hard Protections Check

```mermaid
flowchart TD
    ACTION[File/Git Action] --> SCAN{Scan for violations}

    SCAN --> CHECK1{Removes pre-commit?}
    CHECK1 -->|Yes| BLOCK[BLOCK]
    CHECK1 -->|No| CHECK2{Deletes tests?}

    CHECK2 -->|Yes| BLOCK
    CHECK2 -->|No| CHECK3{Disables CI?}

    CHECK3 -->|Yes| BLOCK
    CHECK3 -->|No| CHECK4{Bypasses hooks?}

    CHECK4 -->|Yes| BLOCK
    CHECK4 -->|No| CHECK5{Force push main?}

    CHECK5 -->|Yes| BLOCK
    CHECK5 -->|No| ALLOW[Allow action]

    BLOCK --> LOG[Log violation]
    LOG --> QUEUE[Queue for review]
```

## Commit Review Pipeline

```mermaid
flowchart TD
    DIFF[Receive Diff] --> SEC[Security Scan]

    SEC --> CRIT{Critical issues?}
    CRIT -->|Yes| BLOCK[BLOCK]
    CRIT -->|No| QUAL[Quality Checks]

    QUAL --> ERR{Errors found?}
    ERR -->|Yes| CHANGES[Changes Requested]
    ERR -->|No| WARN{Warnings only?}

    WARN -->|Yes| APPROVE_WARN[Approved with Notes]
    WARN -->|No| APPROVE[Approved]

    BLOCK --> REPORT[Generate Report]
    CHANGES --> REPORT
    APPROVE_WARN --> REPORT
    APPROVE --> REPORT

    REPORT --> RETURN[Return to Orchestrator]
```

## Subagent Coordination

```mermaid
sequenceDiagram
    participant O as Orchestrator
    participant WR as Web Researcher
    participant CD as Coder
    participant TS as Tester
    participant GH as Git Handler
    participant CR as Commit Reviewer

    O->>WR: Research best practices
    WR-->>O: Findings + recommendations

    O->>CD: Implement feature
    CD-->>O: Code changes + files modified

    O->>TS: Write tests
    TS-->>O: Test files + results

    O->>CR: Review changes
    CR-->>O: Approved / Changes requested

    alt Approved
        O->>GH: Commit + push
        GH-->>O: Commit hash + branch status
    else Changes Requested
        O->>CD: Fix issues
        CD-->>O: Updated code
        O->>CR: Re-review
    end
```

## Memory Bank Data Flow

```mermaid
flowchart LR
    subgraph Input["Input Sources"]
        USER[User]
        GITHUB[GitHub]
        CI[CI System]
    end

    subgraph MB["Memory Bank"]
        PB[project-brief.md]
        TC[technical-context.md]
        SP[system-patterns.md]
        AC[active-context.md]
        PT[progress-tracking.md]
        TQ[task-queue.md]
    end

    subgraph Agents["AI Agents"]
        ORCH[Orchestrator]
        SUB[Subagents]
    end

    USER -->|requirements| PB
    USER -->|architecture| SP

    ORCH -->|read| PB
    ORCH -->|read| TC
    ORCH -->|read| SP
    ORCH <-->|read/write| AC
    ORCH <-->|read/write| PT
    ORCH <-->|read/write| TQ

    ORCH -->|delegate| SUB
    SUB -->|results| ORCH

    GITHUB -->|issues, PRs| TQ
    CI -->|results| PT
```
