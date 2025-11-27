# Subagent: Context Compactor

The Context Compactor is a specialized subagent that performs intelligent context summarization when the orchestrator
approaches token limits. It preserves essential information while dramatically reducing context size.

## Header

| Field | Value |
|-------|-------|
| Model Tier | Medium |
| Context Budget | 10k tokens |
| Write Permissions | Memory-bank files, `.tmp/` archive |
| Timeout | 5 min |
| User Interactive | No |

## Purpose

Long-running agents accumulate context through tool calls, file reads, and subagent results. When context exceeds 80%
of budget, the Context Compactor:

1. Identifies what's essential vs. archivable
2. Summarizes archivable content
3. Creates recovery references
4. Triggers Session Initializer for fresh context window

## Invocation Triggers

| Trigger | Threshold |
|---------|-----------|
| Token count | > 80% of context budget |
| Tool call accumulation | > 50 tool results in context |
| File content volume | > 20 files loaded |
| Explicit `/compact` command | Manual trigger |
| Pre-handoff | Before `/handoff` command |

## Compaction Strategy

### Priority Tiers

Content is categorized into preservation tiers:

```text
Tier 1 - NEVER Compact (Always Keep):
├── Current task definition
├── Active blockers
├── Uncommitted file changes
├── Recent errors (last 3)
└── Key decisions made this session

Tier 2 - Summarize (Keep Summary):
├── Completed subagent outputs
├── Successful tool call results
├── Read file contents (non-active)
└── Research findings

Tier 3 - Archive (Reference Only):
├── Historical tool calls
├── Old error traces (resolved)
├── Verbose logs
└── Exploration results (dead ends)

Tier 4 - Discard (Safe to Remove):
├── Duplicate information
├── Superseded decisions
├── Failed attempts (fully documented)
└── Intermediate states
```

### Summarization Rules

| Content Type | Summarization Approach |
|--------------|----------------------|
| Code file | Keep: path, purpose, key exports. Drop: full content |
| Test results | Keep: pass/fail counts, failing tests. Drop: passing details |
| API responses | Keep: status, key data. Drop: full response |
| Search results | Keep: top 3 findings. Drop: all others |
| Error traces | Keep: error message, root cause. Drop: full stack |
| Subagent output | Keep: status, summary, recommendations. Drop: details |

## Input Contract

```markdown
## Compaction Request

**Trigger**: [threshold | manual | pre_handoff]
**Current Token Count**: [X tokens]
**Context Budget**: [Y tokens]
**Urgency**: [normal | high (>90% budget)]
```

## Output Contract

```markdown
## Compaction Result

**Status**: success | partial | failed
**Tokens Before**: [X]
**Tokens After**: [Y]
**Reduction**: [Z]%

### Preserved (Tier 1)

[List of kept items with brief descriptions]

### Summarized (Tier 2)

[Summaries of compacted content]

### Archived (Tier 3)

| Content | Archive Location | Recovery Reference |
|---------|------------------|-------------------|
| [item] | [path] | [how to restore] |

### Discarded (Tier 4)

[List of safely removed items - for audit]

### Recovery Instructions

If archived content is needed:

1. [How to access archived item 1]
2. [How to access archived item 2]

### Checkpoint Update

[Changes made to progress-checkpoint.md]
```

## Archive Structure

Archived content goes to:

```text
.tmp/context-archive/
├── [session-id]/
│   ├── tool-calls.json       # Serialized tool results
│   ├── file-summaries.md     # File content summaries
│   ├── subagent-outputs.md   # Full subagent outputs
│   └── manifest.json         # Recovery manifest
```

### Recovery Manifest

```json
{
  "session_id": "sess_20250115_143000",
  "archived_at": "2025-01-15T14:30:00Z",
  "items": [
    {
      "id": "tool_001",
      "type": "tool_call",
      "summary": "Read src/auth/login.ts - login endpoint implementation",
      "file": "tool-calls.json",
      "key": "tool_001",
      "recovery_hint": "Re-read file if implementation details needed"
    }
  ]
}
```

## Compaction Algorithm

```text
1. Calculate current token usage
2. If < 80% budget: Exit (no compaction needed)
3. Categorize all context into tiers
4. For Tier 4: Discard immediately
5. For Tier 3: Archive to .tmp/ with manifest
6. For Tier 2: Generate summaries
7. For Tier 1: Keep verbatim
8. Create compacted context
9. Update progress-checkpoint.md with archive references
10. If still > 80%: Trigger Session Initializer for fresh window
```

## Smart Summarization Examples

### File Content Summarization

Before:

```typescript
// src/auth/jwt.ts (200 lines of code)
import jwt from 'jsonwebtoken';
import { config } from '../config';

export interface TokenPayload {
  userId: string;
  email: string;
  role: 'admin' | 'user';
}

export function generateToken(payload: TokenPayload): string {
  return jwt.sign(payload, config.jwtSecret, { expiresIn: '15m' });
}

export function verifyToken(token: string): TokenPayload {
  return jwt.verify(token, config.jwtSecret) as TokenPayload;
}

// ... 180 more lines
```

After:

```text
src/auth/jwt.ts - JWT token utilities
├── Exports: generateToken(payload), verifyToken(token)
├── Token expiry: 15 minutes
├── Payload: userId, email, role
└── Uses: jsonwebtoken library
```

### Subagent Output Summarization

Before (full Coder output):

```markdown
## Task Result

**Task ID**: TASK-042
**Status**: success
**Summary**: Implemented login endpoint with JWT authentication
**Files Modified**:
- src/auth/login.ts (created)
- src/auth/types.ts (created)
- tests/auth/login.test.ts (created)

**Implementation Details**:
[500 lines of detailed implementation notes...]

**Test Results**:
[200 lines of test output...]

**Recommendations**:
- Add rate limiting
- Consider refresh tokens
```

After:

```text
Coder TASK-042: ✓ Login endpoint with JWT
├── Files: login.ts, types.ts, login.test.ts
├── Tests: 12 passing
└── Recommendations: rate limiting, refresh tokens
```

## Failure Modes

| Failure | Recovery |
|---------|----------|
| Archive write fails | Keep in memory, retry, alert |
| Summary loses critical info | Keep original, skip summarization |
| Token count miscalculation | Conservative estimate, compact more |
| Tier classification wrong | Default to higher tier (preserve more) |

## Integration Points

### With Session Initializer

When compaction triggers a fresh context window:

```text
Context Compactor → Progress Checkpoint Update
                 → Archive Creation
                 → Session Initializer Trigger
                 → Fresh Context Window
```

### With Orchestrator

```text
Orchestrator detects 80% threshold
    ↓
Spawn Context Compactor
    ↓
Receive compacted context + archive references
    ↓
Continue with reduced context
```

## See Also

| Related | Purpose |
|---------|---------|
| [Session Initializer](./session-initializer.md) | Post-compaction recovery |
| [Progress Checkpoint](../concepts/progress-checkpoint.md) | State preservation |
| [Autonomous Orchestration](../concepts/autonomous-orchestration.md) | Context management |
| [Self-Healing](../concepts/self-healing.md) | Error recovery |
