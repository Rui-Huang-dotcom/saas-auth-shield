# SaaS Auth Shield - File Manifest

## Overview

Complete file listing and descriptions for the SaaS Auth Shield skill.

This skill is organized around a **navigation-first `SKILL.md`** plus **detailed reference documents**. The main skill file stays focused on triggering, decision-making, and implementation strategy. Longer technical details live in `references/` and example outputs live in `examples/`.

## Files

### Core Documentation

| File | Purpose |
|------|---------|
| `SKILL.md` | Main skill file with positioning, clarification questions, decision paths, and reference navigation |
| `README.md` | Human-facing overview, installation summary, capabilities, and usage examples |
| `INSTALLATION.md` | Step-by-step installation guide for Claude Code, Codex CLI, and manual setup |
| `template.md` | Decision template for capturing only the inputs needed to choose an implementation or migration path |
| `FILE_MANIFEST.md` | This file |
| `LICENSE` | MIT license |
| `.gitignore` | Git ignore rules |

### References

| File | Purpose |
|------|---------|
| `references/env-setup.md` | Environment variables, secrets, provider setup, and deployment configuration |
| `references/fingerprint-options.md` | Open-source vs FingerprintJS Pro tradeoffs and anti-abuse design rationale |
| `references/retrofit-guide.md` | Migration guidance for existing auth systems such as NextAuth, Clerk, Supabase Auth, and Firebase |

### Examples

| File | Purpose |
|------|---------|
| `examples/example-output.md` | Example implementation outputs for multiple project scenarios |

### Scripts

| File | Purpose |
|------|---------|
| `scripts/detect-project.sh` | Detect existing auth, database, UI, and service choices in a project |
| `scripts/validate-skill.sh` | Validate structure, navigation, and reference wiring for this skill |

## File Descriptions

### `SKILL.md`

The main skill file that an agent should read first. It contains:
- skill positioning and scope
- when to use the skill
- minimum clarification questions
- implementation decision paths
- default anti-abuse strategy
- pointers to reference files for deeper details

### `references/env-setup.md`

Use when generating or reviewing:
- `.env.example`
- `.env.local`
- provider secrets
- deployment environment configuration

### `references/fingerprint-options.md`

Use when deciding between:
- open-source fingerprinting
- FingerprintJS Pro
- no fingerprinting

Also explains why the default strategy favors simple hard limits over complex fraud scoring.

### `references/retrofit-guide.md`

Use when migrating or replacing an existing auth layer. Covers:
- NextAuth → Better Auth
- Clerk → Better Auth
- Supabase Auth → Better Auth
- Firebase → Better Auth

### `examples/example-output.md`

Use when the agent needs concrete output patterns for:
- new SaaS auth builds
- lightweight auth without fingerprinting
- Google OAuth-only setups
- retrofitting existing auth
- adding auth to an app that currently has none

### `scripts/detect-project.sh`

Project inspection helper that detects:
- current auth system
- database / ORM choices
- auth route presence
- user/auth schema hints
- frontend/UI stack
- email and fingerprinting dependencies

It is meant to support migration scoping, not just package discovery.

### `scripts/validate-skill.sh`

Validation helper that checks:
- required files and folders
- reference files and examples
- executable scripts
- `SKILL.md` structure
- reference wiring from `SKILL.md`
- frontmatter metadata
- core anti-abuse positioning language

## Recommended Reading Order

### For agents
1. `SKILL.md`
2. `references/retrofit-guide.md` if auth already exists
3. `references/fingerprint-options.md` if fingerprinting choice is unclear
4. `references/env-setup.md` when generating env files or deployment config
5. `examples/example-output.md` only when a concrete output pattern is helpful

### For humans
1. `README.md`
2. `INSTALLATION.md`
3. `SKILL.md`
4. optional reference files based on need

## File Organization

```text
saas-auth-shield/
├── SKILL.md
├── README.md
├── INSTALLATION.md
├── FILE_MANIFEST.md
├── template.md
├── examples/
│   └── example-output.md
├── references/
│   ├── env-setup.md
│   ├── fingerprint-options.md
│   └── retrofit-guide.md
└── scripts/
    ├── detect-project.sh
    └── validate-skill.sh
```

## Distribution Notes

Before distribution:
1. Run `bash scripts/validate-skill.sh`
2. Confirm links and paths still match the current structure
3. Package the full folder, including `references/` and `examples/`

## Version Direction

Current direction:
- emphasize signup-abuse protection over generic auth marketing
- keep `SKILL.md` concise and decision-oriented
- move detailed technical material into `references/`
- keep examples and validation aligned with the new structure
