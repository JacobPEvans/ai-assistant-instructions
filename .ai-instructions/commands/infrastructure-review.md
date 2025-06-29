# Prompt: Review Infrastructure

Review the Infrastructure as Code (IaC) files (Terraform/Terragrunt) for security, cost-efficiency, and best practices.

## Workflow

1. **Code Validation**:
    - `terraform fmt -recursive`
    - `terraform validate`
    - `terragrunt hclfmt`
    - `terragrunt plan` (to check for errors and see the proposed changes)
2. **Security Review**:
    - **No Hardcoded Secrets**: Ensure no secrets, API keys, or credentials are in the code.
    - **Least Privilege**: IAM policies should grant only the necessary permissions.
    - **Network Security**: Security groups and network ACLs should be as restrictive as possible.
    - **Public Exposure**: Identify any resources that are unnecessarily exposed to the public internet.
    - **Encryption**: Verify that data is encrypted at rest and in transit.
3. **Cost Optimization**:
    - **Resource Sizing**: Are the instance types and resource sizes appropriate for the workload?
    - **Unused Resources**: Are there any declared resources that are not being used?
    - **Regional Costs**: Could costs be reduced by using a different region? (Prefer `us-east-2`).
4. **Best Practices**:
    - **State Management**: Is remote state configured securely?
    - **Modularity**: Is the code well-organized into reusable modules?
    - **Tagging**: Are resources tagged according to project standards?
    - **Versioning**: Are provider and module versions pinned?
