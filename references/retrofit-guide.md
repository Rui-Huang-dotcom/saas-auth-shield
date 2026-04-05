# Retrofit Guide

Use this reference when the project already has authentication and the goal is to move toward SaaS Auth Shield without unnecessary rewrites.

Do **not** treat every migration as a full replacement. The default goal is:

- preserve user data
- preserve business logic
- preserve working UI patterns where possible
- replace only the parts that block maintainable auth + signup-abuse protection

## Migration Decision Rule

Before planning a migration, answer these questions:

1. **What exists now?**
   - NextAuth
   - Clerk
   - Supabase Auth
   - Firebase Auth
   - custom credentials/session logic

2. **What must be preserved?**
   - user table and IDs
   - session continuity
   - OAuth providers
   - role/permission logic
   - custom onboarding/business rules

3. **What is the actual target?**
   - Better Auth only
   - Better Auth + fingerprinting
   - Better Auth + per-device limits + logging

Do not migrate more than necessary.

## Migration Strategy by Situation

| Situation | Strategy |
|---|---|
| Existing auth works, but no signup-abuse controls | Keep schema where practical, add logging/fingerprinting first, then replace auth only if needed |
| Existing auth is brittle or limiting product work | Migrate auth layer to Better Auth and preserve app/business logic |
| Existing app already has a stable user table | Extend the existing table instead of rebuilding identity storage |
| Existing sessions are disposable | Recreate sessions during migration instead of over-optimizing session continuity |

## Default Migration Phases

### Phase 1: Inventory

Identify:
- auth routes and middleware
- session handling
- user schema
- OAuth providers
- password reset / email verification flows
- custom hooks into onboarding, billing, referrals, or roles

### Phase 2: Protect Data

Before making changes:
- back up the database
- export or snapshot the current auth-related tables
- record route and env dependencies
- note any custom callbacks/hooks the app depends on

### Phase 3: Extend, Then Replace

Prefer this order:
1. extend schema with anti-abuse fields
2. add event logging and fingerprint support
3. introduce Better Auth routes and config
4. migrate or recreate sessions as needed
5. remove old auth wiring only after verification

This is usually safer than rewriting everything at once.

## Schema Extension Guidance

When the project already has a user table, prefer additive changes such as:

```typescript
export const user = pgTable('user', {
  // keep existing identity fields
  id: uuid('id').primaryKey().defaultRandom(),
  email: text('email').unique().notNull(),
  name: text('name'),

  // add anti-abuse fields only as needed
  fingerprintId: text('fingerprint_id'),
  registrationIp: text('registration_ip'),
  userAgent: text('user_agent'),
  riskLevel: text('risk_level').default('LOW'),

  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});
```

Do not add speculative fields that the app will not use.

## Platform-Specific Notes

### NextAuth → Better Auth

Usually preserve:
- existing user IDs if possible
- OAuth provider choices
- app route structure outside auth routes

Usually replace:
- NextAuth route handlers
- session wiring
- callback-specific auth logic that belongs in Better Auth config

Recommended approach:
- map the existing user/session model first
- extend the user table for anti-abuse fields
- create Better Auth routes under the new route pattern
- verify login, logout, session refresh, OAuth callback, and password/email flows

### Clerk → Better Auth

Usually preserve:
- app UI and business logic
- user profile fields
- role/metadata mapping if present

Usually replace:
- Clerk SDK usage
- managed session primitives in the UI
- direct Clerk-specific middleware/hooks

Recommended approach:
- export/import user data first
- replace `useClerk` / Clerk UI dependencies with app-local auth primitives
- move custom claims into your own schema if still needed

### Supabase Auth → Better Auth

Usually preserve:
- database and broader Supabase usage
- user IDs if possible
- app data model outside auth tables

Usually replace:
- auth session/token handling
- direct dependency on Supabase Auth APIs for login flows

Recommended approach:
- keep Supabase as database if desired
- separate "using Supabase database" from "using Supabase Auth"
- migrate auth behavior without forcing a total database redesign

### Firebase Auth → Better Auth

Usually preserve:
- app data model
- user identity mapping
- UI flows where practical

Usually replace:
- Firebase client/server auth hooks
- token/session assumptions
- Firebase-specific auth middleware

Recommended approach:
- export or map existing users
- establish local session model in Better Auth
- verify any logic coupled to Firebase identity tokens

## Anti-Abuse Retrofit Rule

If the user mainly wants abuse prevention, do **not** force a full auth migration unless it is actually needed.

Sometimes the right sequence is:
1. add fingerprinting + logging around the current system
2. add per-device limits
3. later migrate auth layer if the current stack becomes a bottleneck

This is often the best choice for a busy indie developer.

## Testing Checklist

Before removing the old auth layer, verify:
- existing users can still sign in
- new registrations follow the intended fingerprinting path
- session creation works
- password reset still works if supported
- OAuth callback still works if supported
- signup limits are enforced correctly
- logs are written for registration/login events
- custom onboarding/billing hooks still fire

## Rollback Rule

Always keep rollback simple:
- database backup exists
- old auth code is recoverable until cutover is verified
- env changes are documented
- migration happens in reversible steps when possible

## Suggested Agent Language

Use language like:
- "We should preserve your current user table and add only the fields needed for anti-abuse controls."
- "Let’s migrate the auth layer without rewriting unrelated app logic."
- "If abuse prevention is the main goal, we can add fingerprinting and limits before doing a full auth migration."

Avoid language like:
- "We need to rebuild auth from scratch."
- "We should replace the entire user system immediately."

## When This Reference Is Not Enough

Escalate planning if the project involves:
- multi-tenant auth with complex org models
- enterprise SSO/SAML
- zero-downtime auth migration requirements at high scale
- strict compliance or audit constraints

In those cases, use this guide only as a starting point.
