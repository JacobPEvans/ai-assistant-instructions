---
mode: 'agent'
tools: ['codebase', 'terminalLastCommand', 'runCommands']
description: 'Perform comprehensive security review of infrastructure code and configurations'
---

Your goal is to perform a comprehensive security review of infrastructure code, configurations, and deployment practices.

## Security Review Areas

**Infrastructure Security**
- Network security and access controls
- Encryption at rest and in transit
- IAM policies following least privilege
- Audit logging and monitoring
- Backup encryption and retention

**Application Security**
- Input validation and sanitization
- Authentication and authorization flows
- Session management and password policies
- API security and rate limiting

**Configuration Security**
- Environment separation and isolation
- Secrets management (no hardcoded secrets)
- Dependency vulnerability scanning
- Secure deployment practices

## Assessment Framework

**Risk Levels**
- **Critical**: Immediate security threat, block deployment
- **High**: Address before production release
- **Medium**: Include in next security review cycle
- **Low**: Monitor and consider for future enhancement

**Output Requirements**
For each finding provide:
1. **Severity**: Critical/High/Medium/Low
2. **Description**: Clear security issue explanation
3. **Impact**: Potential consequences
4. **Recommendation**: Specific remediation steps
5. **Cost Impact**: Estimated monthly cost for fixes

**Compliance Focus**
- Data protection requirements (GDPR/CCPA)
- Industry standards (if applicable)
- Internal security policies
- Audit trail documentation

---

*Reference: [Main Security Guidelines](../.github/copilot-instructions.md)*
