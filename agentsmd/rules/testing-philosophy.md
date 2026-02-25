# Testing Philosophy

## Core Preference: Continuous Over One-Time

Always prefer **continuous, real-time monitoring** over one-time tests run only at development or commit time.
One-time tests verify state at a moment in time; continuous monitoring verifies it remains correct.

## When to Use Continuous Monitoring

Use continuous monitoring when the service or infrastructure supports it natively:

- **Cribl**: Health monitoring, pipeline metrics, source/destination connectivity checks
- **Splunk**: Scheduled alerts, correlation searches, monitoring dashboards
- **HAProxy**: Built-in health checks for backend servers
- **Proxmox**: Node health, VM/container status monitoring
- **Any service with a health endpoint**: Configure polling + alerting

Continuous monitoring is preferred whenever a service runs indefinitely and can fail at any point post-deployment.

## When One-Time Tests Are Acceptable

One-time tests are appropriate for:

- **IaC validation**: `terraform plan`, `terraform validate`, `ansible-lint`, syntax checks
- **Linting and formatting**: Pre-commit hooks, `markdownlint-cli2`
- **Unit tests for application code**: TDD red-green-refactor cycle (see the code-standards rule)
- **Smoke tests**: Post-deploy sanity checks (acceptable as a complement to continuous monitoring, not a replacement)

## Proactive Alerting Requirement

Continuous monitoring **MUST** proactively alert the user. Dashboards visible only when manually checked do not satisfy this requirement.

### Approved Alerting Channels (Priority Order)

1. **Slack** (primary) — Cribl, Splunk, and most infrastructure tools have native Slack integrations
2. **Splunk alerts** — Scheduled alerts with email or Slack action; use for log-based anomalies
3. **Email** — Fallback for critical events or tools without Slack integration

When configuring monitoring, wire at least one alerting channel. Silent dashboards are not monitoring — they are archaeology.

## Implementation Guidance

When deploying or configuring a service:

1. **Check for built-in health/monitoring features first** — don't build custom checks for what the tool already provides
2. **Configure alerting alongside the service** — monitoring without alerts is incomplete
3. **Define alert thresholds explicitly** — alerts should fire on actionable conditions, not noise
4. **Document the alert channel** in the service's configuration or `.docs/` folder

## Anti-Patterns

- Relying solely on "it worked when I deployed it" — state drifts
- Configuring dashboards without alert rules
- Using only pre-commit checks for runtime service health
- Silent monitoring (check-only, no notification path)
