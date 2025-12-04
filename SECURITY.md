# Security Policy

## Supported Versions

| Version | Supported |
| ------- | --------- |
| main    | Yes       |
| Everything else | Best effort |

Look, this is a documentation repo with markdown files. The attack surface is pretty small. But if you find something, I want to know.

## Reporting a Vulnerability

**Please don't open a public issue for security vulnerabilities.**

Instead:

1. Email the maintainer directly (check the git log for contact info)
2. Or use GitHub's private vulnerability reporting feature

### What to Include

- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Any suggested fixes (if you have them)

## Response Timeline

I maintain this project in my spare time, so:

- **Acknowledgment**: Within a week, usually faster
- **Assessment**: Within two weeks
- **Fix**: Depends on severity and complexity

For critical issues, I'll prioritize accordingly. For theoretical edge cases in markdown parsing, we might take our time.

## What Counts as a Security Issue

- Secrets accidentally committed (unlikely, but possible)
- Malicious content in instructions that could harm users
- Anything that could compromise systems using these instructions

## What Probably Doesn't Count

- Markdown rendering quirks
- Broken links
- Typos (unless they cause the AI to do something dangerous)

---

*Thanks for helping keep this project safe.*
