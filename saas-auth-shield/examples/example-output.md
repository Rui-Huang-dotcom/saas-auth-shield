# Example Output Patterns

Use this file only when a concrete implementation pattern is helpful.

These are **output patterns**, not strict templates. Adapt them to the user's answers and the existing project state.

## Scenario Index

1. New project + email/password + Google OAuth + fingerprinting
2. New project + email/password only + no fingerprinting
3. New project + Google OAuth only
4. Existing project with NextAuth + migrate to Better Auth + add signup-abuse controls
5. Existing project without auth + add lightweight auth and anti-abuse primitives

---

## 1) New project + full auth + fingerprinting

### When to use this pattern

Use when:
- the project is new
- the user wants both email/password and Google OAuth
- the user wants fingerprinting and signup-abuse protection

### Example response shape

#### Implementation summary

- Better Auth for sessions and providers
- Google OAuth enabled
- email+password enabled with email verification
- forgot-password and reset-password flow included
- user/session/account persistence included
- fingerprint collection on registration
- per-device account limit
- registration and login event logging
- PostgreSQL-backed auth storage, with Supabase PostgreSQL + Drizzle ORM as the default recommendation

#### Example environment variables

```bash
SUPABASE_DATABASE_URL=postgresql://user:password@db.supabase.co:5432/postgres
BETTER_AUTH_SECRET=<your-32-byte-secret>
BETTER_AUTH_URL=http://localhost:3000
RESEND_API_KEY=re_xxxxxxxxxxxxx
GOOGLE_CLIENT_ID=<your-google-client-id>
GOOGLE_CLIENT_SECRET=<your-google-client-secret>
VITE_FINGERPRINT_PUBLIC_API_KEY=<your-fingerprint-key>
MAX_ACCOUNTS_PER_VISITOR_ID=2
MAX_REGISTRATION_ATTEMPTS_PER_IP=5
```

#### Example auth summary

```typescript
export const auth = betterAuth({
  secret: process.env.BETTER_AUTH_SECRET!,
  baseURL: process.env.BETTER_AUTH_URL!,
  emailAndPassword: {
    enabled: true,
    requireEmailVerification: true,
  },
  socialProviders: {
    google: {
      clientId: process.env.GOOGLE_CLIENT_ID!,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
    },
  },
});
```

#### Example anti-abuse summary

```typescript
async function enforceSignupGuards({ visitorId, ip }: { visitorId: string; ip: string }) {
  await checkDeviceLimit(visitorId);
  await checkRegistrationRateLimit(ip);
  await logRegistrationAttempt({ visitorId, ip });
}
```

#### Output checklist

- auth routes configured
- env file generated
- schema includes anti-abuse fields
- registration flow collects fingerprint
- signup limit enforcement implemented
- dashboard/log view shows security events

---

## 2) New project + email/password only + no fingerprinting

### When to use this pattern

Use when:
- the user wants the smallest auth footprint
- abuse risk is low or currently unknown
- the product does not need fingerprinting yet

### Example response shape

#### Implementation summary

- Better Auth with email/password only
- email verification enabled
- forgot-password and reset-password flow included by default
- user/session/account persistence included
- no fingerprinting
- keep schema minimal
- still recommend basic logging and IP rate limiting

#### Example note to user

> Since fingerprinting is off, I’d still keep email verification and request-rate limits so registration isn’t completely unguarded.

#### Output checklist

- auth configured
- email verification included
- password reset included if requested
- basic audit logging included
- no fingerprinting dependencies added

---

## 3) New project + Google OAuth only

### When to use this pattern

Use when:
- the product wants minimal signup friction
- email/password is intentionally out of scope
- the user wants a simpler launch setup

### Example response shape

#### Implementation summary

- Better Auth with Google OAuth only
- provider config, callback handling, and account persistence included
- no password flows
- add fingerprinting only if abuse concern is real

#### Example note to user

> Google-only signup is simpler, but it does not remove the need for abuse controls if the product has free credits, referrals, or other incentives.

#### Output checklist

- Google provider configured
- callback routes verified
- no password-reset/email-password UI generated
- abuse controls included only if requested

---

## 4) Existing project with NextAuth + migrate to Better Auth + add signup-abuse controls

### When to use this pattern

Use when:
- the app already uses NextAuth
- the user wants Better Auth
- the user also wants fingerprinting or per-device signup limits

### Example response shape

#### Migration summary

- preserve user table where practical
- replace NextAuth route wiring with Better Auth
- add anti-abuse fields incrementally
- keep unrelated app logic unchanged

#### Example migration plan

1. back up auth-related tables
2. inspect current user/session schema
3. extend user table with fingerprint and logging fields
4. add Better Auth config and routes
5. migrate or recreate sessions as needed
6. add signup guards to registration flow
7. verify existing users can still sign in

#### Example note to user

> Since your main goal is signup-abuse protection, I’d avoid a full rewrite. We can preserve the user model and add the anti-abuse layer while moving auth routing to Better Auth.

#### Output checklist

- old auth inventory documented
- migration steps listed in order
- rollback note included
- anti-abuse additions separated from core auth migration

---

## 5) Existing project without auth + add lightweight auth and anti-abuse primitives

### When to use this pattern

Use when:
- the app already exists
- there is no auth yet
- the user wants a simple auth layer plus basic signup protection

### Example response shape

#### Implementation summary

- add Better Auth without restructuring the entire app
- extend existing database rather than redesigning it
- add fingerprinting only if the product has real signup-abuse risk

#### Example note to user

> I’ll fit auth around your current app structure instead of treating this like a greenfield starter template.

#### Output checklist

- current routes and schema respected
- auth added incrementally
- anti-abuse controls sized to actual risk
- deploy/run instructions tailored to the existing app

---

## Output Style Rules

When generating a real response from this skill:

- start with a short implementation summary
- make the chosen auth and anti-abuse strategy explicit
- explain tradeoffs plainly
- avoid claiming perfect fraud prevention
- preserve existing app logic where possible
- prefer simple defaults, then mention optional stricter controls
