Your goal is to review infrastructure-as-code for best practices, cost optimization, and security compliance.

## Infrastructure Review Focus Areas

### Code Quality & Best Practices

**Resource Organization**
- Verify logical resource grouping and module structure
- Check for appropriate use of data sources vs. hardcoded values
- Review resource naming conventions and tagging standards
- Validate module reusability and documentation

**State Management**
- Confirm proper state file isolation and backend configuration
- Verify state locking mechanisms when available
- Check for sensitive data in state files
- Review state backup and recovery procedures

**Dependencies & Modules**
- Validate module versioning and source specifications
- Check for circular dependencies
- Review module input/output definitions
- Verify proper dependency ordering

### Cost Optimization

**Resource Sizing**
- Review instance types and sizes for actual usage patterns
- Check for over-provisioned resources
- Verify auto-scaling configurations
- Identify opportunities for reserved instances or savings plans

**Cost Controls**
- Ensure resource tagging for cost allocation
- Verify budget alerts and cost monitoring
- Check for unused or orphaned resources
- Review data transfer and storage costs

**Regional Considerations**
- Validate region selection for cost optimization
- Check for unnecessary cross-region data transfer
- Review availability zone distribution for cost vs. reliability

### Security & Compliance

**Network Security**
- Review network configuration and subnetting
- Validate security group and firewall rules
- Check for public resource exposure
- Verify load balancer and routing security

**Access Control**
- Review access policies for least privilege
- Check resource-based policies
- Validate cross-account access patterns
- Ensure multi-factor authentication where appropriate

**Data Protection**
- Verify encryption at rest and in transit
- Check backup and retention policies
- Review key management practices
- Validate data classification and handling

### Operational Excellence

**Monitoring & Alerting**
- Review monitoring metrics and alarms
- Check logging configuration and retention
- Verify monitoring coverage for all critical resources
- Validate alerting thresholds and notification targets

**Backup & Recovery**
- Review backup strategies and schedules
- Verify cross-region backup replication when applicable
- Check recovery testing procedures
- Validate RTO/RPO requirements

**Deployment Practices**
- Review CI/CD integration and automation
- Check for proper environment promotion
- Verify rollback procedures and capabilities
- Validate change management processes

## Review Process

### Pre-Review Setup

1. **Environment Preparation**
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
