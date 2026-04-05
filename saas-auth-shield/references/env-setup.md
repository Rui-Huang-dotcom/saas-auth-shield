# Environment Setup Reference

Use this reference when generating or reviewing environment variables for a project using SaaS Auth Shield.

Do **not** read the entire file unless env setup is part of the current task. Most tasks only need one section.

## Decision Summary

Choose env variables based on the selected feature set:

| Feature set | Required env vars |
|---|---|
| Better Auth only | `BETTER_AUTH_SECRET`, `BETTER_AUTH_URL`, `DATABASE_URL` |
| Email verification / transactional email | `RESEND_API_KEY`, `RESEND_FROM_EMAIL` |
| Google OAuth | `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET` |
| FingerprintJS Pro | `VITE_FINGERPRINT_PUBLIC_API_KEY` |
| Signup-abuse limits | `MAX_ACCOUNTS_PER_VISITOR_ID`, `MAX_REGISTRATION_ATTEMPTS_PER_IP` |

## Minimal Baseline

For most projects, start here:

```env
BETTER_AUTH_SECRET=your_random_secret_here
BETTER_AUTH_URL=http://localhost:3000
DATABASE_URL=postgresql://postgres:password@host:5432/postgres
MAX_ACCOUNTS_PER_VISITOR_ID=2
MAX_REGISTRATION_ATTEMPTS_PER_IP=5
```

Then add email, OAuth, or fingerprinting variables only if those features are enabled.

## Core Rules

- never commit real secrets
- use `.env.example` for placeholders only
- keep development and production values separate
- do not invent provider variables the app does not actually use
- if fingerprinting is disabled, do not leave dead fingerprint env vars in the template

## By Feature

### Better Auth

Required when Better Auth is enabled:

```env
BETTER_AUTH_SECRET=your_random_secret_here
BETTER_AUTH_URL=http://localhost:3000
```

Guidance:
- generate `BETTER_AUTH_SECRET` with a high-entropy random value
- use the real production URL in deployed environments

### Database

Required for all non-demo setups:

```env
DATABASE_URL=postgresql://postgres:password@host:5432/postgres
```

Optional only if migrations use a different connection:

```env
MIGRATION_DATABASE_URL=postgresql://postgres:password@host:5432/postgres
```

Guidance:
- prefer a direct database connection for migrations
- keep naming consistent across docs and code

### Resend / Email

Add only if the app needs:
- email verification
- password reset
- transactional auth email

```env
RESEND_API_KEY=re_xxxxxxxxxxxxx
RESEND_FROM_EMAIL=noreply@yourdomain.com
```

If email flows are not part of the project, do not include these as required variables.

### Google OAuth

Add only if Google login is enabled:

```env
GOOGLE_CLIENT_ID=your_client_id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your_client_secret
```

Do not add a separate `OAUTH_REDIRECT_URI` unless the actual implementation needs it. In many projects, the callback URL is implied by route structure and provider configuration.

### Fingerprinting

#### Open-source fingerprinting

Usually no API key is required.

If the project wants an explicit feature flag, use something simple like:

```env
FINGERPRINT_USE_OPENSOURCE=true
```

Do not pretend the open-source path needs a hosted secret if it does not.

#### FingerprintJS Pro

Add only if the project explicitly chooses Pro:

```env
VITE_FINGERPRINT_PUBLIC_API_KEY=your_public_api_key
```

Optional extras only if the implementation really uses them:

```env
FINGERPRINT_REGION=us
FINGERPRINT_RISK_THRESHOLD=0.7
```

### Signup-Abuse Limits

Recommended defaults:

```env
MAX_ACCOUNTS_PER_VISITOR_ID=2
MAX_REGISTRATION_ATTEMPTS_PER_IP=5
```

Guidance:
- keep the defaults simple
- increase strictness only when abuse justifies it
- explain shared-device tradeoffs before tightening limits aggressively

## Suggested `.env.example` Pattern

Use placeholders only:

```env
BETTER_AUTH_SECRET=<generate-a-random-secret>
BETTER_AUTH_URL=http://localhost:3000
DATABASE_URL=postgresql://postgres:password@host:5432/postgres

RESEND_API_KEY=<optional>
RESEND_FROM_EMAIL=<optional>
GOOGLE_CLIENT_ID=<optional>
GOOGLE_CLIENT_SECRET=<optional>
VITE_FINGERPRINT_PUBLIC_API_KEY=<optional>

MAX_ACCOUNTS_PER_VISITOR_ID=2
MAX_REGISTRATION_ATTEMPTS_PER_IP=5
```

Avoid bloated templates full of unused variables.

## Local vs Production

### Local development

Typical local values:

```env
BETTER_AUTH_URL=http://localhost:3000
```

Use test/dev provider credentials where possible.

### Production

Typical production values:

```env
BETTER_AUTH_URL=https://yourdomain.com
```

In production:
- use real verified email sender domains
- verify OAuth callback URLs
- store secrets in the platform secret manager, not in committed files

## Common Mistakes

Avoid these mistakes:
- mixing `SUPABASE_DATABASE_URL` and `DATABASE_URL` inconsistently
- including fingerprint env vars when fingerprinting is disabled
- requiring Resend env vars when there is no email verification flow
- adding placeholder secrets that look real enough to be copied unchanged
- forgetting to change `BETTER_AUTH_URL` between dev and production

## Minimal Validation Checklist

Before saying env setup is complete, verify:
- required variables match enabled features
- no unused provider variables are marked required
- dev/prod URLs are sensible
- secrets are placeholders in `.env.example`, not real values
- abuse-limit values are present if signup protection is enabled

## Related References

- `references/fingerprint-options.md` — decide whether fingerprinting should be open-source, Pro, or disabled
- `references/retrofit-guide.md` — check migration implications before changing env layout in an existing project
