# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-01-XX - Production Readiness Release

### Added

- **Documentation Index** - New `docs/README.md` with navigation and learning paths
- **Troubleshooting Guide** - `docs/troubleshooting.md` with common issues and solutions
- **Prerequisites Section** - Clear documentation of required tools (Git 2.30+, GitHub CLI 2.0+)
- **Quick Start Verification** - Installation verification step using `claude doctor`
- **Security Reporting** - Explicit vulnerability reporting link in SECURITY.md using GitHub Security Advisories
- **Contributing Guidance** - Worktree-based development workflow documentation

### Fixed

- **[CRITICAL] Command Injection (#279, #316)** - Fixed unsafe `xargs bash -c` pattern in PR comment limit workflow
  - Replaced with safe jq-based approach that doesn't pass untrusted data to shell
- **[HIGH] Git Branch Injection (#329, #330)** - Added input validation to session-naming-setup.sh
  - New `validate_branch_name()` function prevents injection attacks
- **[HIGH] Bash For Loop Violations (#239)** - Removed for loops from cleanup-stale-branches.sh
  - Replaced with grep-based comparisons and array expansion
  - Complies with permission system requirements
- **Documentation Clarity (#328, #344, #292)** - Improved accuracy of documentation
  - Clarified that Copilot support is minimal
  - Emphasized worktree-based development workflow
  - Added explicit vulnerability reporting contact

### Changed

- **README Structure** - Reorganized for better first-time user experience
  - Added Prerequisites section
  - Enhanced Quick Start with verification step
  - Clarified nix-config is optional for advanced use
  - Added "Need Help?" section with clear navigation
- **CONTRIBUTING.md** - Aligned with worktree-based workflow
  - Replaced `git checkout -b` with `/init-worktree` command
  - Added link to Worktree Workflow documentation
- **Permission System** - Hooks temporarily disabled during critical updates

### Security

- **[CRITICAL]** Fixed command injection in PR comment limit check workflow
- **[CRITICAL]** Fixed git branch injection vulnerability in session setup
- **[HIGH]** Removed bash for loops that violated permission system architecture
- All changes designed to support hardened permission model
- Added GitHub Security Advisory reporting link

### Notes

- This is the first production-ready release (v1.0)
- Breaking changes include removal of unsafe patterns (bash for loops)
- See [SECURITY.md](SECURITY.md) for vulnerability reporting
- See [CONTRIBUTING.md](CONTRIBUTING.md) for development workflow

---

## Previous Versions

Earlier versions and development history tracked in [git commit history](https://github.com/JacobPEvans/ai-assistant-instructions/commits/main).
