# SaaS Auth Shield

[中文说明](./README.zh-CN.md)

Add SaaS authentication with **signup-abuse protection**.

SaaS Auth Shield is an Agent Skill for projects that need more than a basic login flow. It helps an agent implement authentication plus practical anti-abuse controls such as device fingerprinting, per-device account limits, registration/login event logging, and migration support for existing auth systems.

## Why this skill exists

Most SaaS auth templates stop at:
- email/password
- OAuth
- forgot password
- session handling

That is enough to let users in, but often not enough to slow down:
- duplicate registrations
- multi-account farming
- free-credit abuse
- invite/referral abuse
- repeated low-cost signup attempts

This skill focuses on that missing layer: **signup-abuse protection for SaaS apps**.

## What makes it different

- **Auth + anti-abuse together** — not just login/signup pages
- **Device fingerprinting support** — open-source or FingerprintJS Pro
- **Per-device account limits** — simple, auditable enforcement
- **Retrofit-friendly** — works for existing auth systems, not only greenfield projects
- **Indie-dev friendly** — favors practical rules over complex fraud modeling

## Best fit

Use this skill when you need:
- email/password and/or Google OAuth
- anti-abuse signup protection
- device fingerprinting as a risk signal
- per-device registration caps
- registration/login event logging
- migration from an existing auth system such as NextAuth, Clerk, Supabase Auth, or Firebase

This skill is especially useful for:
- indie developers
- small SaaS teams
- products with free tiers, credits, referrals, or account farming risk

## Included by default

Unless the user explicitly asks for something smaller, the skill bundles related auth pieces together.

### If email + password is enabled
The default implementation includes:
- user/session/account persistence
- email verification
- forgot-password and reset-password flow
- email delivery setup when required, such as Resend

### If Google OAuth is enabled
The default implementation includes:
- provider configuration
- callback and session handling
- account persistence and basic user profile storage

### If fingerprinting is enabled
The default implementation includes:
- fingerprint collection during registration
- per-device signup limits
- registration/login event logging

### Database default
- Reuse and extend an existing suitable database where practical.
- If no suitable database exists, default to a PostgreSQL-backed setup.
- The recommended default is **Supabase PostgreSQL + Drizzle ORM**.

## Example prompts

- `Add auth to my Next.js SaaS, but stop users from mass-registering accounts.`
- `Retrofit Better Auth into this app and add fingerprint-based signup limits.`
- `We have free credits and need basic signup abuse protection.`
- `Migrate from NextAuth without rewriting the whole app, then add per-device account limits.`

## How it works

The skill keeps the main decision flow simple:

1. Choose fingerprinting level
   - open-source
   - FingerprintJS Pro
   - no fingerprinting
2. Choose login methods
   - email+password
   - Google OAuth
   - both
3. Choose project path
   - new project
   - existing project with auth
   - existing project without auth

Then it applies a lightweight strategy:
- **Base auth** — Better Auth, sessions, email verification, OAuth if needed
- **Signup-abuse controls** — fingerprinting, per-device limits, IP/device logging
- **Operator visibility** — audit trail, rejection reasons, adjustable limits

## Folder structure

```text
saas-auth-shield/
├── SKILL.md
├── README.md
├── README.zh-CN.md
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

## Key files

### `SKILL.md`
Navigation-first skill file containing:
- positioning and scope
- clarification questions
- decision paths
- default implementation strategy
- pointers to deeper references

### `references/env-setup.md`
Use when generating or reviewing env vars and provider configuration.

### `references/fingerprint-options.md`
Use when deciding between open-source fingerprinting, FingerprintJS Pro, or disabling fingerprinting.

### `references/retrofit-guide.md`
Use when migrating or replacing an existing auth layer.

### `examples/example-output.md`
Use when a concrete output pattern is helpful.

### `template.md`
Use when summarizing the minimum decisions needed before implementation or migration.

## Helper scripts

### `scripts/detect-project.sh`
Detects:
- current auth system
- database / ORM choices
- auth route presence
- user/auth schema hints
- frontend/UI stack
- email and fingerprinting dependencies

```bash
bash scripts/detect-project.sh
```

### `scripts/validate-skill.sh`
Validates the structure and checks that `SKILL.md` correctly points to the reference files.

```bash
bash scripts/validate-skill.sh
```

## Installation

See [INSTALLATION.md](./INSTALLATION.md) for full setup instructions.

Quick start:

```bash
git clone https://github.com/Rui-Huang-dotcom/saas-auth-shield.git
cp -r saas-auth-shield ~/.claude/skills/saas-auth-shield/
```

For Codex-style setups, copy it into your equivalent skills directory.

## Positioning notes

This skill is intentionally **not** a full fraud platform.

It is designed to:
- raise the cost of abusive signups
- give SaaS projects practical anti-abuse defaults
- stay understandable for indie developers and small teams

It is **not** designed to promise:
- perfect fraud detection
- unique human identification
- enterprise-grade behavioral risk modeling

## Distribution checklist

Before publishing or sharing:

1. Run `bash scripts/validate-skill.sh`
2. Confirm `SKILL.md` still matches the actual structure
3. Include `references/` and `examples/` in the package

## License

MIT — free for personal and commercial use.
