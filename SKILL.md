---
name: saas-auth-shield
description: "Add or retrofit SaaS authentication with signup-abuse protection. Use when a project needs email/password or OAuth login plus device fingerprinting, per-device account limits, registration abuse prevention, or migration from existing auth systems such as NextAuth, Clerk, Supabase Auth, or Firebase. Best for SaaS apps that need practical anti-abuse rules, auditability, and a simpler alternative to full custom fraud systems."
---

# SaaS Auth Shield

## Overview

Build or upgrade SaaS authentication with a specific goal: **reduce abusive registrations, repeated signups, and easy multi-accounting**.

Use this skill when the app needs:

- email/password and/or OAuth login
- device fingerprinting as an anti-abuse signal
- per-device account limits or registration gating
- security logging around signup and login events
- migration from an existing auth setup without rebuilding everything from scratch

This is **not** a generic security platform and it does **not** promise perfect fraud detection. The default approach is deliberately practical:

- prefer **simple, auditable rules** over opaque scoring systems
- use fingerprinting to **raise the cost of abuse**, not to uniquely identify humans
- combine auth setup with **signup protection** so teams do not ship login flows that are easy to farm

## Core Positioning

Most SaaS templates stop at "users can sign up and log in." This skill focuses on the next problem: **what happens when people start abusing registration**.

Use SaaS Auth Shield when the real requirement is something like:

- "Add auth, but stop users from mass-registering accounts"
- "We have a free tier / credits / invite rewards and need basic abuse controls"
- "Retrofit Better Auth into an existing app and add fingerprint-based signup limits"
- "Keep the implementation simple enough for an indie dev or small team to maintain"

## What to Clarify

Ask only the minimum questions needed to choose an implementation path:

1. **Abuse protection level**
   - Options: `open-source fingerprinting` / `FingerprintJS Pro` / `no fingerprinting` / `unsure`
2. **Login methods**
   - Options: `email+password` / `Google OAuth` / `both`
3. **Project state**
   - Options: `new project` / `existing project with auth` / `existing project without auth`

If the user is unsure, prefer the simpler option and explain the tradeoff briefly.

## Decision Path

### New project

- set up auth, schema, routes, UI, and abuse-prevention defaults together
- default to maintainable choices over maximal complexity

### Existing project with auth

- detect the current auth system first
- preserve custom business logic where possible
- replace or retrofit the auth layer without unnecessary rewrites
- read `references/retrofit-guide.md` before planning a migration

### Existing project without auth

- add auth and signup-protection primitives around the current app structure
- preserve current database and UI patterns where practical

## Default Implementation Strategy

Unless the user asks otherwise, implement a layered but lightweight setup:

1. **Base auth layer**
   - Better Auth with email/password, Google OAuth, or both
   - email verification and session handling

2. **Signup abuse layer**
   - device fingerprint collection
   - per-device registration limits
   - IP and device logging for registration and login events

3. **Operator visibility**
   - clear rejection reasons where appropriate
   - audit trail for suspicious or blocked registrations
   - configuration that can be tightened later without redesigning the whole auth system

Default to practical controls that small teams can understand and maintain:

- Better Auth for authentication
- FingerprintJS or open-source fingerprinting for device signals
- configurable hard limits such as max accounts per device
- database-backed logging for auditability
- deployment-ready environment and migration guidance

### Bundling Rules

Apply these defaults unless the user explicitly asks for something smaller or different:

- If `email+password` is enabled, include:
  - user/session/account persistence
  - email verification
  - forgot-password and reset-password flow
  - email provider setup such as Resend when email delivery is required

- If `Google OAuth` is enabled, include:
  - provider configuration
  - callback/session handling
  - account persistence and basic user profile storage

- If `fingerprinting` is enabled, include:
  - fingerprint collection during registration
  - per-device signup limits
  - registration/login event logging

- If the project already has a suitable database, reuse and extend it where practical.
- Otherwise, default to a PostgreSQL-backed setup, with Supabase PostgreSQL + Drizzle ORM as the recommended default.

## Reference Files

Read these only when needed:

- `references/env-setup.md` — environment variables, secrets, provider setup, and deployment configuration
- `references/fingerprint-options.md` — open-source vs Pro fingerprinting tradeoffs and why hard limits are the default
- `references/retrofit-guide.md` — migration guidance for existing auth systems such as NextAuth, Clerk, Supabase Auth, and Firebase
- `examples/example-output.md` — example outputs and implementation patterns for different project scenarios

## Output Expectations

When using this skill:

- explain the chosen auth and anti-abuse approach in plain language
- call out tradeoffs and boundaries instead of overstating fraud protection
- keep the implementation understandable for an indie developer or small team
- prefer simple defaults first, then note where stricter controls can be added later
