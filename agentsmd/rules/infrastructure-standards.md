# Concept: Infrastructure Standards

This document outlines the universal standards for managing Infrastructure as Code (IaC).

## General Principles

- **[Idempotency](./idempotency.md)**: All infrastructure code must be idempotent.
- **Modularity**: Organize code into reusable modules.
- **State Management**: Use remote state with locking to prevent conflicts.

## Security

- **Least Privilege**: IAM policies and resource permissions should be as restrictive as possible.
- **Network Security**: Use firewalls, security groups, and network ACLs to control traffic.
- **Encryption**: Encrypt data at rest and in transit.

## Cost Management

- **Resource Sizing**: Choose cost-effective resource sizes and instance types.
- **Tagging**: Tag all resources for cost allocation and tracking.
- **Monitoring**: Set up budget alerts to monitor spending.

## Technology-Specific Guidelines

### Terraform/Terragrunt

- **Use variables instead of hardcoded values**: Make infrastructure reusable and configurable
- **Enable state locking**: Use DynamoDB (AWS) or equivalent for state locking to prevent concurrent modifications
