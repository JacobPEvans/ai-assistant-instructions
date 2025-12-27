#!/usr/bin/env python3
"""
Claude Code PreToolUse hook for token limit enforcement.
Blocks file modifications (Write/Edit tools) that would exceed token limits.

Configuration: .token-limits.yaml
"""
import fnmatch
import json
import re
import subprocess
import sys
from pathlib import Path
from typing import Optional


def load_config() -> tuple[dict[str, int], int]:
    """Load token limits from .token-limits.yaml"""
    config_path = Path('.token-limits.yaml')
    if not config_path.exists():
        return {}, 2000

    try:
        import yaml
        with open(config_path) as f:
            config = yaml.safe_load(f) or {}
        limits = config.get('limits', {})
        default = config.get('defaults', {}).get('max_tokens', 2000)
        return limits, default
    except Exception:
        return {}, 2000


def get_file_limit(file_path: str, limits: dict[str, int], default_limit: int) -> int:
    """Find applicable token limit for file"""
    for pattern, limit in limits.items():
        if fnmatch.fnmatch(file_path, pattern):
            return limit
    return default_limit


def count_tokens(content: str) -> Optional[int]:
    """Count tokens in content using atc"""
    try:
        result = subprocess.run(
            ['atc', '-m', 'sonnet'],
            input=content,
            capture_output=True,
            text=True,
            timeout=10
        )
        output = result.stdout + result.stderr

        # Extract token count
        for line in output.split('\n'):
            if 'token' in line.lower():
                match = re.search(r'(\d+)\s+token', line)
                if match:
                    return int(match.group(1))

        # Try parsing first number
        try:
            return int(output.strip().split()[0])
        except (ValueError, IndexError):
            return None
    except (subprocess.TimeoutExpired, subprocess.SubprocessError, OSError):
        return None


def validate_file(file_path: str, content: str) -> Optional[dict[str, int | str]]:
    """Check if file would violate token limits"""
    limits, default_limit = load_config()
    file_limit = get_file_limit(file_path, limits, default_limit)

    # Skip binary files
    if file_path.endswith(('.png', '.jpg', '.pdf', '.bin', '.zip')):
        return None

    # Count tokens
    tokens = count_tokens(content)
    if tokens is None:
        # Can't count, allow (will catch in CI)
        return None

    if tokens > file_limit:
        return {
            'file': file_path,
            'tokens': tokens,
            'limit': file_limit,
            'excess': tokens - file_limit
        }

    return None


def main() -> None:
    try:
        hook_input = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        sys.exit(0)  # Invalid input, allow

    tool_name = hook_input.get('tool_name', '')
    tool_input = hook_input.get('tool_input', {})

    # Only check Write and Edit tools
    if tool_name not in ['Write', 'Edit']:
        sys.exit(0)

    file_path = tool_input.get('file_path', '')
    content = tool_input.get('content', '')

    if not file_path or not content:
        sys.exit(0)

    # Validate
    violation = validate_file(file_path, content)
    if violation:
        error = (
            f"❌ Token limit violation: {violation['file']}\n"
            f"   Tokens: {violation['tokens']} (limit: {violation['limit']}, "
            f"excess: +{violation['excess']})\n"
            f"\n"
            f"This file would exceed the configured token limit.\n"
            f"Options:\n"
            f"  1. Split into multiple focused files\n"
            f"  2. Extract verbose content to subagent\n"
            f"  3. Remove unnecessary examples/documentation\n"
            f"  4. Adjust limits in .token-limits.yaml (not recommended)"
        )
        print(error, file=sys.stderr)
        sys.exit(2)  # Block the operation

    sys.exit(0)  # Allow


if __name__ == '__main__':
    main()
