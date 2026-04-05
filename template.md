# SaaS Auth Shield Decision Template

Use this template to collect only the information needed to choose an implementation path.

Do not treat every field as mandatory. Skip sections that do not apply.

---

## 1. Core Decisions

### Abuse protection level

- [ ] Open-source fingerprinting
- [ ] FingerprintJS Pro
- [ ] No fingerprinting
- [ ] Unsure

**Decision / notes:**

---

### Login methods

- [ ] Email + password
- [ ] Google OAuth
- [ ] Both

**Decision / notes:**

**Default bundling rules:**
- If **Email + password** is selected, default to including email verification, forgot password, reset password, and email delivery setup.
- If **Google OAuth** is selected, default to including provider config, callback/session handling, and account persistence.

---

### Project state

- [ ] New project
- [ ] Existing project with auth
- [ ] Existing project without auth

**Decision / notes:**

---

## 2. Existing Project Snapshot

Fill this section only if the project already exists.

### Current auth

- Auth system: __________
- Session model: __________
- OAuth providers already in use: __________
- Password/email flows already in use: __________

### Current data model

- Database / ORM: __________
- Existing user table: __________
- Existing session/account tables: __________
- Custom user/profile fields that must survive: __________

**Database rule:**
- Reuse and extend an existing suitable database where practical.
- If no suitable database exists, default to PostgreSQL, with Supabase PostgreSQL + Drizzle ORM as the recommended default.

### Current app constraints

- UI framework / routing style: __________
- Middleware or guards already in use: __________
- Business logic hooked into signup/login: __________
- Billing / onboarding / referral flows affected by auth: __________

---

## 3. Chosen Strategy

### Auth path

- [ ] Better Auth only
- [ ] Better Auth + signup-abuse controls
- [ ] Add anti-abuse controls first, migrate auth later

**Reasoning:**

---

### Anti-abuse path

- [ ] Per-device account limits
- [ ] IP-based registration limits
- [ ] Registration/login event logging
- [ ] Security dashboard or admin visibility
- [ ] Keep it minimal for now

**Reasoning:**

**Bundling rule:**
- If fingerprinting is enabled, default to registration-time fingerprint collection, per-device signup limits, and registration/login event logging.

---

## 4. Required Environment / Providers

Check only what is actually needed.

- [ ] `BETTER_AUTH_SECRET`
- [ ] `BETTER_AUTH_URL`
- [ ] `DATABASE_URL`
- [ ] `RESEND_API_KEY`
- [ ] `RESEND_FROM_EMAIL`
- [ ] `GOOGLE_CLIENT_ID`
- [ ] `GOOGLE_CLIENT_SECRET`
- [ ] `VITE_FINGERPRINT_PUBLIC_API_KEY`
- [ ] `MAX_ACCOUNTS_PER_VISITOR_ID`
- [ ] `MAX_REGISTRATION_ATTEMPTS_PER_IP`

**Notes:**

---

## 5. Output Plan

### Files or areas likely to change

- [ ] auth config
- [ ] auth routes
- [ ] database schema
- [ ] env files
- [ ] login/register UI
- [ ] middleware / guards
- [ ] migration scripts
- [ ] audit logging

### Implementation notes

- What must be preserved? __________
- What can be replaced safely? __________
- What should be added incrementally? __________

---

## 6. Validation Checklist

Before implementation is considered complete:

- [ ] chosen auth path is explicit
- [ ] fingerprinting choice is explicit
- [ ] enabled features match env vars
- [ ] migration scope is limited to what the user actually needs
- [ ] signup-abuse controls are explained without overstating fraud protection
- [ ] rollback considerations exist for migrations

---

## 7. Short Summary for the User

Use this space to write the actual implementation summary in plain language.

**Summary:**

---

## 8. Suggested Agent Workflow

1. Capture the three core decisions
2. If the project already exists, inspect current auth and data model
3. Choose the smallest migration or implementation path that solves the problem
4. Read `references/fingerprint-options.md` if fingerprinting choice is unclear
5. Read `references/retrofit-guide.md` if auth already exists
6. Read `references/env-setup.md` only when generating env/config output
7. Use `examples/example-output.md` only when a concrete output pattern would help
