# Troubleshooting

Common issues and solutions for using this repository.

## Setup Issues

### "Claude Code not finding commands"

**Problem**: You run a command like `/init-worktree` but Claude says it's not recognized.

**Solution**:

1. Verify `.claude/` directory exists in your project
2. Check that symlinks are valid: `find . -type l -xtype l` (should return nothing)
3. Make sure you've created symlinks to AGENTS.md or CLAUDE.md
4. Run `claude doctor` to verify Claude Code installation

### "Symlinks not working on Windows"

**Problem**: Symlinks fail or create text files instead of symbolic links.

**Solution**:

- Windows requires either:
  - Developer Mode enabled (Settings > Update & Security > For developers)
  - Administrator privileges
- Recommended: Use WSL2 with Ubuntu for better Git and symlink support

### "Permission denied when running scripts"

**Problem**: Scripts in `agentsmd/commands/` fail with permission errors.

**Solution**:

1. Make scripts executable: `chmod +x agentsmd/commands/*.sh`
2. Check that you have the required commands in your allow list
3. See [Permission System](../agentsmd/docs/permission-system.md) for details

## Git Workflow Issues

### "Can't create worktree"

See AGENTS.md "Git Workflow Patterns" section for worktree requirements and troubleshooting.

### "Broken symlinks after rebase"

**Problem**: Symlinks break after rebasing or switching branches.

**Solution**:

1. Verify symlinks are still valid: `find . -type l -xtype l`
2. Recreate broken symlinks: `ln -sf path/to/target broken-link`
3. Don't delete agentsmd/ on rebase - keep it available

## Documentation Issues

### "Links in documentation don't work"

**Problem**: Markdown links in docs/ return 404 or don't navigate correctly.

**Solution**:

1. Use relative paths like `[Link](../agentsmd/commands/)`
2. Always include `.md` extension in links - for example, link to `guide.md` not `guide`
3. Avoid paths with spaces or special characters
4. Test locally with a markdown viewer before committing

### "Markdown lint errors"

**Problem**: Pre-commit hooks reject your markdown with lint errors.

**Solution**:

1. Check the error message for the specific rule
2. Run locally: `markdownlint-cli2 '**/*.md'`
3. Fix common issues:
   - Lines > 160 characters: Break into multiple lines
   - Trailing whitespace: Remove spaces at end of lines
   - Missing file extensions in links: Add `.md`
   - Inconsistent heading levels: Use proper hierarchy (# ## ### etc)

## Performance Issues

### "Slow command execution"

**Problem**: Commands like `/review-pr` or `/analyze-issue` are very slow.

**Solution**:

1. Check PR size - large PRs with many changes take longer
2. Reduce scope if possible - review individual files at a time

## Getting Help

- 🐛 [Open an Issue](https://github.com/JacobPEvans/ai-assistant-instructions/issues)
- 📖 [Read the Main README](../README.md)
- 🔒 [Security Issues](../SECURITY.md)

---

*Still stuck? Don't hesitate to open an issue - that's what it's there for!*
