# Shared: Timeout Budgets

Single source of truth for all operation timeouts.

## Subagent Timeouts

| Subagent | Timeout | On Timeout |
|----------|---------|------------|
| Web Researcher | 5 min | Return partial findings |
| Coder | 10 min | Return partial with TODOs |
| Tester | 10 min | Return partial test suite |
| Git Handler | 2 min | Return status, queue retry |
| PR Resolver | 10 min | Return partial resolution |
| Doc Reviewer | 3 min | Return partial lint results |
| Security Auditor | 10 min | Return partial audit |
| Dependency Manager | 5 min | Return partial audit |
| Issue Creator | 10 min | Create best-effort issue |
| Issue Resolver | 30 min | Return partial, queue rest |
| Commit Reviewer | 5 min | Return partial review |

## Operation Timeouts

| Operation | Timeout | Action |
|-----------|---------|--------|
| Single tool call | 2 min | Retry once, skip |
| Subagent task | 10 min | Return partial |
| CI wait | 15 min | Proceed with warning |
| Workflow step | 30 min | Checkpoint + queue |
| PR feedback loop | 5 iterations | Mark complex |

## Watchdog Timeouts

| Mode | User Response | Coding | Blocked |
|------|--------------|--------|---------|
| attended | ∞ | N/A | N/A |
| semi-attended | 15 min | 30 min | 10 min |
| unattended | 5 min | 15 min | 5 min |

## Retry Strategy

```text
Attempt 1: Immediate
Attempt 2: 2s + jitter
Attempt 3: 4s + jitter
Attempt 4: 8s + jitter
Attempt 5: Escalate
```

See [Self-Healing](../concepts/self-healing.md) for escalation paths.
