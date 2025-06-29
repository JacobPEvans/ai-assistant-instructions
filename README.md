# AI Assistant Instructions

Comprehensive AI assistant instructions combining GitHub Copilot and Claude Code workflows for consistent, high-quality development assistance.

## Overview

This repository provides centralized AI instruction management with modular, reusable configurations.
It is optimized for both GitHub Copilot and Claude Code integration.
It features dual AI system compatibility with standardized workflows, security scanning, and cost-conscious development practices.

## Quick Start

- **Explore the Instructions**: The core instructions are in the `.ai-instructions` directory.
- **Vendor-Specific Integration**: The `.claude`, `.copilot`, and `.github` directories contain links to these core instructions.
- **Use the Commands**: Leverage the standardized commands like `commit` and `review-code` with your AI assistant.

## Architecture

This project uses a centralized, single-source-of-truth model.
The `.ai-instructions` directory contains the canonical documentation, which is then referenced by vendor-specific files.
This adheres to the DRY (Don't Repeat Yourself) principle, making maintenance easier.

For more details, see the main instruction file:
**[`.ai-instructions/INSTRUCTIONS.md`](.ai-instructions/INSTRUCTIONS.md)**.
