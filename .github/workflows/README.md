# GitHub Actions Workflows

This directory contains automated CI/CD workflows for the repository.

## Workflows

### Claude Code Review (`claude.yml`)

Automated code review using Anthropic's Claude AI on pull requests.

**Trigger**: Pull request opened or synchronized

**Permissions**:

- `contents: read` - Read repository contents
- `pull-requests: write` - Comment on pull requests
- `issues: read` - Read issue information
- `id-token: write` - Generate OIDC tokens (fallback for OIDC auth)

**Configuration**:

```yaml
- name: Run Claude Code Review
  uses: anthropics/claude-code-action@v1
  with:
    anthropic_api_key: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
    github_token: ${{ secrets.GITHUB_TOKEN }}
```

**Important Notes**:

1. **External Contributors**: This workflow uses `github_token: ${{ secrets.GITHUB_TOKEN }}` to support PRs from:
   - GitHub Copilot bot
   - External contributors
   - Users without write access

2. **Security**: The built-in `GITHUB_TOKEN` provides minimal required permissions:
   - Scoped to the PR context
   - Cannot access repository secrets
   - Limited to commenting on PRs
   - Follows principle of least privilege

3. **Why not `pull_request_target`?**: Using `pull_request_target` would grant write access to untrusted code,
   creating a security vulnerability. The current approach is safer.

**Troubleshooting**:

If Claude Code fails with "User does not have write access":

- Ensure `github_token: ${{ secrets.GITHUB_TOKEN }}` is present
- Verify permissions block includes required scopes
- Check that CLAUDE_CODE_OAUTH_TOKEN secret is configured

### Markdown Linting (`markdownlint.yml`)

Validates markdown files using markdownlint-cli2.

**Trigger**: Push to any branch, pull request

**Configuration**: See `.markdownlint-cli2.jsonc` for rules

## Adding New Workflows

When adding new workflows:

1. **Use minimal permissions**: Only request necessary scopes
2. **Support external contributors**: Include `github_token: ${{ secrets.GITHUB_TOKEN }}`
3. **Document**: Add section to this README
4. **Test**: Verify workflow works with external PR scenarios
5. **Security**: Never use `pull_request_target` unless absolutely necessary with proper safeguards

## Security Best Practices

### GitHub Token Usage

- **Built-in `GITHUB_TOKEN`**: Automatically provided, limited scope
- **Custom PAT**: Only if built-in token lacks required permissions
- **Secrets**: Store sensitive values in repository/organization secrets

### Pull Request Triggers

- **`pull_request`**: ✅ Safe - runs in PR context with limited permissions
- **`pull_request_target`**: ⚠️ Dangerous - runs with write access, requires safeguards
- **`workflow_run`**: 🔒 Secure - staged approach for untrusted code

### External Contributors

Design workflows to work with:

- Contributors without write access
- Forks from external users
- Bot accounts (Copilot, Dependabot, etc.)

## References

- [GitHub Actions Security](https://docs.github.com/en/actions/security-guides)
- [GITHUB_TOKEN Permissions](https://docs.github.com/en/actions/security-guides/automatic-token-authentication)
- [Anthropic Claude Code Action](https://github.com/anthropics/claude-code-action)
