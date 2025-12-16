# macOS Keychain Setup for AI API Keys

This document describes how to set up the `ai-secrets` keychain for storing API keys used by the AI orchestration system.

## Overview

API keys are stored in a dedicated macOS Keychain called `ai-secrets`. This approach:

- Keeps secrets out of files and environment variables
- Uses native macOS security infrastructure
- Supports runtime retrieval without exposure
- Works with Nix-managed configuration

## One-Time Setup

### 1. Create the Keychain

```bash
security create-keychain -p "" ai-secrets.keychain-db
```

This creates an empty keychain with no password. The keychain file is stored at:
`~/Library/Keychains/ai-secrets.keychain-db`

### 2. Add to Keychain Search List

```bash
security list-keychains -d user -s ai-secrets.keychain-db login.keychain-db
```

### 3. Unlock Keychain (if needed)

```bash
security unlock-keychain ai-secrets.keychain-db
```

## Adding API Keys

### Anthropic (Claude)

```bash
security add-generic-password -a "$USER" -s "ANTHROPIC_API_KEY" -w "sk-ant-..." ai-secrets.keychain-db
```

### OpenAI

```bash
security add-generic-password -a "$USER" -s "OPENAI_API_KEY" -w "sk-..." ai-secrets.keychain-db
```

### Google (Gemini)

```bash
security add-generic-password -a "$USER" -s "GEMINI_API_KEY" -w "..." ai-secrets.keychain-db
```

### OpenRouter

```bash
security add-generic-password -a "$USER" -s "OPENROUTER_API_KEY" -w "sk-or-..." ai-secrets.keychain-db
```

### Grok (xAI)

```bash
security add-generic-password -a "$USER" -s "XAI_API_KEY" -w "..." ai-secrets.keychain-db
```

### Azure OpenAI

```bash
security add-generic-password -a "$USER" -s "AZURE_API_KEY" -w "..." ai-secrets.keychain-db
security add-generic-password -a "$USER" -s "AZURE_API_BASE" -w "https://..." ai-secrets.keychain-db
```

## Retrieving Keys (Runtime)

The orchestration system retrieves keys at runtime using:

```bash
security find-generic-password -a "$USER" -s "ANTHROPIC_API_KEY" -w ai-secrets.keychain-db
```

This is handled automatically by the PAL MCP secrets wrapper.

## Updating Keys

To update an existing key, delete and re-add:

```bash
security delete-generic-password -a "$USER" -s "ANTHROPIC_API_KEY" ai-secrets.keychain-db
security add-generic-password -a "$USER" -s "ANTHROPIC_API_KEY" -w "new-key" ai-secrets.keychain-db
```

## Listing Keys

To see what keys are stored:

```bash
security dump-keychain ai-secrets.keychain-db | grep "svce"
```

## Security Notes

1. **Never commit keys** - This keychain stores secrets that must never be in git
2. **Backup carefully** - If backing up the keychain, ensure the backup is encrypted
3. **One machine only** - Each machine needs its own keychain setup
4. **No sharing** - Do not sync this keychain via iCloud or other services

## Troubleshooting

### "keychain not found"

Ensure the keychain is in the search list:

```bash
security list-keychains -d user
```

### "permission denied"

Unlock the keychain:

```bash
security unlock-keychain ai-secrets.keychain-db
```

### Key not retrieved

Verify the key exists and service name matches:

```bash
security find-generic-password -a "$USER" -s "ANTHROPIC_API_KEY" ai-secrets.keychain-db
```

## Integration with Nix

Set `services.ai-orchestration.secretsBackend = "keychain"` in your Nix module to use this keychain.
No additional configuration is needed once keys are added.
