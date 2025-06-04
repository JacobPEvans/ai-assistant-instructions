Your goal is to perform a comprehensive security review of infrastructure code, configurations, and deployment practices.

## Security Review Checklist

### Infrastructure as Code (Terraform/Terragrunt)

**Access Control & Identity Management**
- Verify principle of least privilege in all access policies
- Check for overly permissive resource policies
- Ensure multi-factor authentication for administrative access
- Review cross-account access patterns

**Network Security**
- Validate security group and firewall configurations
- Check for unnecessary open ports and exposed services
- Verify network configuration and subnetting
- Review load balancer and routing configurations

**Data Protection**
- Confirm encryption at rest for all data stores
- Verify encryption in transit for all communications
- Check backup encryption and retention policies
- Review key management and rotation practices

**Monitoring & Logging**
- Ensure audit logging is enabled for all systems
- Verify log aggregation and retention policies
- Check for security monitoring and alerting
- Review access logging for all services

### Application Security

**Input Validation**
- Check for SQL injection vulnerabilities
- Verify XSS protection mechanisms
- Validate file upload restrictions
- Review API parameter validation

**Authentication & Authorization**
- Verify secure session management
- Check for proper authentication flows
- Review authorization logic and role definitions
- Validate password policies and requirements

**Secrets Management**
- Ensure no hardcoded secrets in code
- Verify proper secret rotation policies
- Check secret access logging and auditing
- Review secret storage and encryption

### Configuration Security

**Environment Configuration**
- Verify environment separation and isolation
- Check for secure configuration management
- Review environment variable handling
- Validate deployment security practices

**Dependency Management**
- Check for known vulnerabilities in dependencies
- Verify dependency update and patching processes
- Review third-party service integrations
- Check for supply chain security measures

## Cost Impact Assessment

Evaluate security measures against cost implications:

- **High Priority (Implement Regardless)**: Critical security controls
- **Medium Priority (Cost-Benefit Analysis)**: Enhanced monitoring and logging
- **Low Priority (Budget Permitting)**: Advanced threat detection services

## Compliance Considerations

- GDPR/CCPA data protection requirements
- Industry-specific compliance (PCI, HIPAA, SOX)
- Internal security policies and standards
- Audit trail and documentation requirements

## Output Format

For each finding, provide:

1. **Severity Level**: Critical, High, Medium, Low
2. **Description**: Clear explanation of the security issue
3. **Impact**: Potential consequences if not addressed
4. **Recommendation**: Specific steps to remediate
5. **Cost Estimate**: Approximate monthly cost impact (if applicable)

## Follow-up Actions

- Document all findings in security review report
- Create remediation tickets with priority assignments
- Schedule follow-up review after remediation
- Update security baseline documentation

---

*Reference: [Main Security Guidelines](../.github/copilot-instructions.md)*
