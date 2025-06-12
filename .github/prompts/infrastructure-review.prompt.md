---
mode: 'agent'
tools: ['codebase', 'usages', 'problems', 'changes', 'terminalLastCommand', 'githubRepo', 'editFiles', 'runCommands', 'get_syntax_docs', 'mermaid-diagram-validator', 'mermaid-diagram-preview']
description: 'Review Terraform/Terragrunt infrastructure code for best practices, cost optimization, and security'
---

Your goal is to review infrastructure-as-code (Terraform/Terragrunt) for best practices, cost optimization, and security compliance with AWS focus.

If defined, you shall only act on repository: ${input:repository} . If defined, no files outside of ${input:repository} shall be modified.

If defined, you shall only act on the single file: ${input:file}

## Key Review Areas

**Code Quality**
- Resource organization and module structure
- Naming conventions and tagging standards
- State management and backend configuration
- Module dependencies and versioning

**Cost Optimization**
- Resource sizing and instance types
- Regional placement (prefer us-east-2)
- Budget compliance (under $20/month per project)
- Unused or over-provisioned resources

**Security**
- Network security and access controls
- Encryption at rest and in transit
- IAM policies following least privilege
- Public resource exposure validation

**Operational Excellence**
- Monitoring, logging, and alerting setup
- Backup and recovery strategies
- CI/CD integration and deployment practices

## Output Requirements

Provide review with:
1. **Risk Level**: Green (low), Yellow (medium), Red (high risk)
2. **Cost Estimate**: Monthly AWS costs
3. **Critical Issues**: Must fix before deployment
4. **Recommendations**: Prioritized improvement list
5. **Security Score**: Assessment of security posture

Focus on actionable feedback that improves reliability, reduces costs, and enhances security.
   ```bash
   # Format code before review
   terraform fmt -recursive
   terragrunt hclfmt

   # Validate syntax
   terraform validate
   terragrunt validate-inputs
   ```

2. **Plan Generation**
   ```bash
   # Generate plan for review
   terragrunt plan -out=review.tfplan

   # Never run apply during review!
   ```

### Cost Analysis

**Monthly Cost Estimation**
- Use AWS Cost Calculator for major resources
- Compare costs across regions
- Evaluate cost vs. performance trade-offs
- Document cost justification for expensive resources

**Budget Compliance**
- Verify total monthly cost stays within project limits
- Check cost allocation by environment (dev/test/prod)
- Review cost trends and growth patterns

### Security Validation

**Automated Checks**
- Run security scanning tools
- Check for secrets in configuration files
- Verify compliance with security baselines
- Review access patterns and permissions

**Manual Review**
- Network topology and segmentation
- Data flow and protection mechanisms
- Incident response and monitoring capabilities

## Output Requirements

### Review Documentation

Create review report with:

1. **Executive Summary**: Key findings and recommendations
2. **Cost Analysis**: Estimated monthly costs and optimization opportunities
3. **Security Assessment**: Risk level and required mitigations
4. **Best Practices**: Compliance with organizational standards
5. **Action Items**: Prioritized list of required changes

### Follow-up Actions

- **Critical Issues**: Must be addressed before deployment
- **High Priority**: Address within current sprint
- **Medium Priority**: Include in next release cycle
- **Low Priority**: Consider for future optimization

## Risk Assessment

**Deployment Risk Levels**
- **Green**: Low risk, standard deployment process
- **Yellow**: Medium risk, additional testing required
- **Red**: High risk, requires architecture review and approval

---

*Reference: [Main Instructions](../copilot-instructions.md)*
*See also: [Security Review Process](security-review.prompt.md)*
