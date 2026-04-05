# SaaS Auth Shield

Authentication for SaaS apps with a stronger focus on **signup-abuse prevention**, not just login flows.

Most SaaS templates stop at email/password or OAuth. This skill goes one step further by helping an agent implement practical anti-abuse controls such as device fingerprinting, per-device account limits, and registration/login event logging.

## 📁 Folder Structure

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

## 🚀 Installation

See [INSTALLATION.md](./INSTALLATION.md) for full setup instructions.

Quick start:

```bash
git clone https://github.com/Rui-Huang-dotcom/saas-auth-shield.git
cp -r saas-auth-shield ~/.claude/skills/saas-auth-shield/
```

## 🎯 What This Skill Is For

Use this skill when a project needs one or more of the following:

- email/password and/or Google OAuth
- anti-abuse signup protection
- device fingerprinting as a risk signal
- per-device registration caps
- audit logging around registration and login events
- migration from an existing auth system

Typical prompts this skill should handle well:

- "Add auth, but stop users from mass-registering accounts"
- "We have free credits and need basic signup abuse protection"
- "Retrofit Better Auth into this Next.js app and add fingerprint-based limits"
- "Migrate from NextAuth/Clerk/Supabase Auth without rewriting the whole app"

## 🧠 How the Skill Thinks

The main design principle is simple:

- prefer **simple, auditable controls** over complex fraud systems
- use fingerprinting to **raise the cost of abuse**, not to uniquely identify a person
- keep the result understandable for an indie developer or small team

The default implementation tends to layer:

1. **Base auth** — Better Auth, sessions, email verification, OAuth if needed
2. **Signup abuse controls** — fingerprinting, per-device limits, IP/device logging
3. **Operator visibility** — audit trail, rejection reasons, adjustable limits

## 📚 Key Files

### `SKILL.md`
The navigation-first skill file. It contains:
- scope and positioning
- clarification questions
- decision paths
- default implementation strategy
- pointers to deeper reference docs

### `references/env-setup.md`
Read when setting up provider keys, env vars, or deployment config.

### `references/fingerprint-options.md`
Read when deciding between open-source fingerprinting and FingerprintJS Pro.

### `references/retrofit-guide.md`
Read before migrating from an existing auth system.

### `examples/example-output.md`
Read when a concrete implementation pattern is useful.

### `template.md`
Use when capturing the minimum decisions needed before implementation or migration.

## 🔧 Helper Scripts

### `scripts/detect-project.sh`
Detects:
- current auth system
- database / ORM choices
- auth route presence
- user/auth schema hints
- frontend/UI stack
- email and fingerprinting dependencies

Usage:

```bash
bash scripts/detect-project.sh
```

### `scripts/validate-skill.sh`
Validates the current structure and checks that `SKILL.md` correctly points to the reference files.

The detector and template are meant to work together:
- run `scripts/detect-project.sh` when the existing project shape is unclear
- use `template.md` to summarize decisions before implementation

Usage:

```bash
bash scripts/validate-skill.sh
```

## 📖 Example Flow

```text
User: "I need auth for my SaaS, but I also want to stop duplicate registrations."

Assistant:
1. Do you want fingerprinting? (open-source / Pro / no / unsure)
2. Which login methods do you need? (email+password / Google / both)
3. Is this a new project, or does auth already exist?
```

From there, the skill should choose one of three paths:
- new project
- existing project with auth
- existing project without auth

## 🔐 Positioning Notes

This skill is intentionally **not** framed as a full fraud platform.

It is best for:
- indie developers
- small SaaS teams
- products with free tiers, invite rewards, or account farming risk
- teams that want practical protection without building an entire custom risk engine

It is not ideal if the real requirement is:
- enterprise-grade fraud modeling
- heavy behavioral analysis
- a guarantee of unique human identity
- highly regulated identity verification workflows

## 📦 Distribution Checklist

Before publishing or sharing:

1. Run `bash scripts/validate-skill.sh`
2. Confirm `SKILL.md` still matches the actual structure
3. Include `references/` and `examples/` in the package

## 📝 License

MIT — free for personal and commercial use.
