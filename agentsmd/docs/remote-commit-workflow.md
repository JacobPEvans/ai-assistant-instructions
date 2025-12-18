# Remote Commit Workflow

This document describes how to make commits to GitHub repositories without requiring a local clone, using the GitHub API via the GitHub CLI.

## Overview

The remote commit workflow enables you to update repository files directly through the GitHub API. This is useful for:

- Automated updates from CI/CD pipelines
- Quick single-file updates without cloning large repositories
- Scripted documentation updates
- Cross-repository synchronization tasks
- Environments where git clone is not practical

Three approaches are available:

1. **Contents API** - Simple single-file updates
2. **Git Data API** - Multi-file atomic commits
3. **Workflow Dispatch** - Trigger GitHub Actions workflows

## Prerequisites

### GitHub CLI Installation

Install the GitHub CLI if not already present:

```bash
# macOS (Homebrew)
brew install gh

# Linux (Debian/Ubuntu)
sudo apt install gh

# Other platforms
# See: https://cli.github.com/
```

### Authentication

Authenticate with GitHub:

```bash
gh auth login
```

Follow the prompts to authenticate via browser or token.

Verify authentication:

```bash
gh auth status
```

## Approach 1: Single-File Updates (Contents API)

The Contents API is the simplest approach for updating a single file.

### When to Use Contents API

- Updating one file per commit
- Simple, straightforward updates
- README updates, configuration changes, etc.

### Contents API Usage

```bash
scripts/remote-commit.sh single-file <repo> <branch> <file-path> <content-file> <message>
```

### Example: Update README

```bash
# Prepare content
cat > /tmp/readme.txt << 'EOF'
# My Project

Updated documentation with latest changes.
EOF

# Commit to repository
./scripts/remote-commit.sh single-file \
    myorg/myrepo \
    main \
    README.md \
    /tmp/readme.txt \
    "docs: Update README with latest changes"
```

### Contents API Workflow

1. Fetches current file SHA (if file exists)
2. Base64 encodes new content
3. Sends PUT request to `/repos/{owner}/{repo}/contents/{path}`
4. GitHub creates commit automatically

### Contents API Limitations

- Only one file per commit
- File size limited to 1 MB
- Cannot delete files (use empty content instead)
- Cannot commit to multiple paths atomically

## Approach 2: Multi-File Commits (Git Data API)

The Git Data API provides full control for creating commits with multiple files.

### When to Use Git Data API

- Updating multiple files in one commit
- Need atomic commits across multiple files
- Complex repository operations
- Programmatic git operations

### Git Data API Usage

```bash
scripts/remote-commit.sh multi-file <repo> <branch> <message> <file:content> [file:content...]
```

### Example: Update Multiple Documentation Files

```bash
# Prepare content files
cat > /tmp/guide.md << 'EOF'
# User Guide
Latest updates...
EOF

cat > /tmp/api.md << 'EOF'
# API Reference
New endpoints...
EOF

# Commit all files atomically
./scripts/remote-commit.sh multi-file \
    myorg/myrepo \
    main \
    "docs: Update user guide and API reference" \
    docs/guide.md:/tmp/guide.md \
    docs/api.md:/tmp/api.md
```

### Git Data API Workflow

1. Fetches current commit SHA for the branch
2. Gets base tree SHA from current commit
3. Creates blob objects for each file's new content
4. Creates new tree with updated blobs
5. Creates commit pointing to new tree
6. Updates branch reference to new commit

### Git Data API Limitations

- More complex than Contents API
- Requires multiple API calls
- Need to handle tree construction manually (script handles this)

## Approach 3: Workflow Dispatch

Trigger GitHub Actions workflows remotely.

### When to Use Workflow Dispatch

- Triggering deployments
- Running automated processes
- Initiating builds or tests
- Scheduled tasks with parameters

### Workflow Dispatch Usage

```bash
scripts/remote-commit.sh workflow <repo> <workflow-id> [inputs-json]
```

### Example: Trigger Deployment

```bash
# Trigger workflow with inputs
./scripts/remote-commit.sh workflow \
    myorg/myrepo \
    deploy.yml \
    '{"environment":"production","version":"v1.2.3"}'

# Trigger workflow without inputs
./scripts/remote-commit.sh workflow \
    myorg/myrepo \
    build.yml
```

### Workflow Requirements

Your workflow must include `workflow_dispatch` trigger:

```yaml
name: Deploy
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Deployment environment'
        required: true
        default: 'staging'
      version:
        description: 'Version to deploy'
        required: false
```

### Workflow Dispatch Process

1. Sends POST request to `/repos/{owner}/{repo}/actions/workflows/{workflow_id}/dispatches`
2. GitHub queues workflow run with provided inputs
3. Workflow executes according to its definition

## Comparison: When to Use Each Approach

| Approach | Best For | Pros | Cons |
|----------|----------|------|------|
| **Contents API** | Single file updates | Simple, easy to use | One file only, 1MB limit |
| **Git Data API** | Multi-file commits | Atomic, full control | More complex, multiple API calls |
| **Workflow Dispatch** | Automation triggers | Flexible, reusable | Requires workflow definition |

## Security Considerations

### GitHub Authentication

- GitHub CLI uses OAuth tokens stored securely
- Tokens respect repository permissions
- Same access control as git push

### Best Practices

1. **Use fine-grained tokens** - Create tokens with minimal required permissions
2. **Never commit secrets** - The helper script does not expose credentials
3. **Verify repository** - Always double-check the repository name before committing
4. **Test on branches** - Test scripts on feature branches before using on main
5. **Audit logs** - All API commits are logged in GitHub's audit log

### Rate Limiting

GitHub API has rate limits:

- 5,000 requests/hour for authenticated requests
- Lower limits for unauthenticated requests

The helper script makes multiple API calls for Git Data API approach:

- Single-file: 2 API calls (get SHA + commit)
- Multi-file: 4+ API calls (get commit, get tree, create blobs, create tree, create commit, update ref)

For bulk operations, consider:

- Batching updates
- Using workflow dispatch to delegate to GitHub Actions
- Implementing exponential backoff on rate limit errors

## Error Handling

### Common Errors

#### Authentication Failed

```text
[ERROR] Not authenticated with GitHub CLI
Run: gh auth login
```

**Solution**: Run `gh auth login` to authenticate.

#### File Not Found

```text
[ERROR] Content file not found: /tmp/myfile.txt
```

**Solution**: Verify the local file path exists and is readable.

#### Permission Denied

```text
[ERROR] Resource not accessible by integration
```

**Solution**: Verify you have push access to the repository and branch.

#### Branch Protection

```text
[ERROR] Required status check "ci" is expected
```

**Solution**: Updates to protected branches may require:

- Status checks to pass
- Pull request reviews
- Specific users/teams authorization

Use a feature branch and create a PR instead.

## Advanced Usage

### Atomic Multi-Repository Updates

Update multiple repositories in sequence:

```bash
#!/bin/bash
REPOS=("org/repo1" "org/repo2" "org/repo3")
MESSAGE="docs: Update API version to v2"

for repo in "${REPOS[@]}"; do
    ./scripts/remote-commit.sh single-file \
        "$repo" \
        main \
        docs/api-version.md \
        /tmp/api-version.md \
        "$MESSAGE"
done
```

### Conditional Updates

Only update if content differs:

```bash
#!/bin/bash
REPO="myorg/myrepo"
FILE_PATH="VERSION"
NEW_CONTENT="2.1.0"

# Get current content
CURRENT=$(gh api "repos/$REPO/contents/$FILE_PATH" --jq '.content' | base64 -d)

if [[ "$CURRENT" != "$NEW_CONTENT" ]]; then
    echo "$NEW_CONTENT" > /tmp/version.txt
    ./scripts/remote-commit.sh single-file \
        "$REPO" \
        main \
        "$FILE_PATH" \
        /tmp/version.txt \
        "chore: Bump version to $NEW_CONTENT"
else
    echo "Version unchanged, skipping commit"
fi
```

### Integration with CI/CD

Use in GitHub Actions:

```yaml
name: Update Documentation
on:
  schedule:
    - cron: '0 0 * * *'

jobs:
  update-docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Generate documentation
        run: ./scripts/generate-docs.sh > /tmp/docs.md

      - name: Commit to docs repo
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          ./scripts/remote-commit.sh single-file \
            myorg/docs-repo \
            main \
            reference/api.md \
            /tmp/docs.md \
            "docs: Auto-update API reference"
```

## Troubleshooting

### Script Permission Denied

```bash
chmod +x scripts/remote-commit.sh
```

### Command Not Found: jq

Install `jq` for JSON processing:

```bash
# macOS
brew install jq

# Linux
sudo apt install jq
```

### API Rate Limit Exceeded

Wait for rate limit reset or implement exponential backoff:

```bash
# Check rate limit status
gh api rate_limit
```

### Commit Not Appearing

- Verify branch name is correct
- Check commit was created: visit the commit URL returned by script
- Ensure you're looking at the correct branch in GitHub UI

## Additional Resources

- [GitHub REST API Documentation](https://docs.github.com/en/rest)
- [Contents API Reference](https://docs.github.com/en/rest/repos/contents)
- [Git Data API Reference](https://docs.github.com/en/rest/git)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [Helper Script](../scripts/remote-commit.sh)
