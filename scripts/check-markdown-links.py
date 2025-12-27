#!/usr/bin/env python3
"""Check for broken file links in markdown files."""

import os
import re
import sys
from pathlib import Path

# ANSI colors
RED = '\033[0;31m'
GREEN = '\033[0;32m'
NC = '\033[0m'

def find_markdown_files(root_dir):
    """Find all markdown files excluding .git directory."""
    for root, dirs, files in os.walk(root_dir):
        # Skip .git directory
        if '.git' in dirs:
            dirs.remove('.git')

        for file in files:
            if file.endswith('.md'):
                yield Path(root) / file

def extract_file_links(content):
    """Extract file links from markdown content (not URLs)."""
    # Pattern: ]( ... ) but not http:// or https:// or mailto:
    pattern = r'\]\(([^)#]+)\)'

    for match in re.finditer(pattern, content):
        link = match.group(1).strip()

        # Skip empty links
        if not link:
            continue

        # Skip URLs
        if link.startswith(('http://', 'https://', 'mailto:')):
            continue

        # Skip placeholders and template variables
        if (link.startswith('<') and link.endswith('>')) or \
           (link.startswith('{') and link.endswith('}')):
            continue

        yield link

def check_links():
    """Check all markdown files for broken links."""
    errors = 0
    root_dir = Path.cwd()

    for md_file in find_markdown_files(root_dir):
        # Resolve symlinks to get the actual file location
        real_file = md_file.resolve()
        file_dir = real_file.parent

        try:
            content = md_file.read_text(encoding='utf-8')
        except Exception as e:
            print(f"{RED}✖{NC} Error reading {md_file}: {e}")
            errors += 1
            continue

        for link in extract_file_links(content):
            # Build target path
            if link.startswith('/'):
                # Absolute path from repo root
                target = root_dir / link[1:]
            else:
                # Relative path from the actual file location (not symlink)
                target = file_dir / link

            # Normalize the path
            target = target.resolve()

            # Check if file or directory exists
            if not target.exists():
                print(f"{RED}✖{NC} Broken link in {md_file}: {link}")
                print(f"   Expected file at: {target}")
                errors += 1

    print()
    if errors > 0:
        print(f"{RED}Found {errors} broken file link(s){NC}")
        return 1
    else:
        print(f"{GREEN}✓ All file links are valid{NC}")
        return 0

if __name__ == '__main__':
    sys.exit(check_links())
