# Fingerprinting Options and Anti-Abuse Strategy

Use this reference when deciding whether a project should use:

- open-source fingerprinting
- FingerprintJS Pro
- no fingerprinting

Do **not** read this file by default for every task. Read it when the user is unsure, when cost/accuracy tradeoffs matter, or when the project has real signup-abuse pressure.

## Decision Summary

Choose the simplest option that matches the abuse risk.

| Situation | Recommendation | Why |
|---|---|---|
| MVP, low traffic, budget-sensitive, wants basic friction | Open-source fingerprinting | Cheap, simple, good enough for basic signup gating |
| SaaS with free tier / credits / referral abuse risk | FingerprintJS Pro | Better accuracy and harder to bypass |
| Internal tool, B2B app, or low abuse concern | No fingerprinting | Avoid extra complexity when abuse prevention is not important |
| User is unsure | Default to open-source fingerprinting | Keeps cost low and still raises abuse cost |

## Core Position

Fingerprinting is a **risk signal**, not proof of unique human identity.

Use it to:
- slow down repeated signups
- enforce per-device limits
- log suspicious registration behavior
- support simple anti-abuse rules

Do **not** present it as:
- perfect fraud detection
- guaranteed unique-user identification
- a replacement for rate limits, email verification, or captcha/challenges

## Default Anti-Abuse Policy

Unless the user asks for something more advanced, use this layered policy:

1. **Base controls**
   - email verification
   - session handling
   - password policy

2. **Signup-abuse controls**
   - fingerprint collection on registration
   - max accounts per device
   - IP-based registration attempt limits

3. **Visibility controls**
   - log registration and login events
   - keep rejection reasons understandable
   - make thresholds configurable

## Recommended Defaults

```env
MAX_ACCOUNTS_PER_VISITOR_ID=2
MAX_REGISTRATION_ATTEMPTS_PER_IP=5
```

These defaults are intentionally simple. Tighten them only if the app is actually seeing abuse.

## Open-Source vs Pro

### Open-source fingerprinting

Typical package:
- `@fingerprintjs/fingerprintjs`

Choose this when:
- the project is early-stage
- abuse pressure is moderate or unknown
- the user wants no recurring vendor cost
- the goal is practical deterrence, not maximum resilience

Pros:
- free
- easy to integrate
- privacy-friendlier than hosted solutions
- enough for basic multi-account friction

Cons:
- easier to evade
- lower confidence than Pro
- weaker for high-volume abuse environments

Implementation stance:
- use for device-level gating
- keep rules simple
- do not oversell detection quality

### FingerprintJS Pro

Choose this when:
- the app has free credits, referral abuse, or repeated farming pressure
- the project is consumer-facing or international
- the user wants stronger anti-evasion behavior
- the cost is justified by abuse reduction

Pros:
- better accuracy
- harder to bypass
- better maintained anti-evasion layer
- more suitable for serious SaaS abuse pressure

Cons:
- paid
- vendor dependency
- more operational complexity
- privacy and compliance questions may matter more

Implementation stance:
- still pair it with hard limits and logging
- do not turn it into a black-box scoring system unless the user explicitly wants that

### No fingerprinting

Choose this when:
- the app is internal or invite-only
- abuse prevention is not a current requirement
- the user wants the smallest auth footprint

If fingerprinting is disabled, still recommend:
- email verification
- rate limiting
- audit logging

## Why Hard Limits Are the Default

Prefer hard limits over custom fraud scoring unless the user explicitly wants a more complex system.

Recommended default rule:

```text
Maximum accounts per device: 2
If the device is already at the limit, reject the registration.
```

Why this is the default:
- easy to explain
- easy to maintain
- easy to audit
- immediately useful for indie SaaS products

Tradeoffs to mention:
- shared devices can be unfairly limited
- browser/device changes reduce stability
- determined abusers can still work around it

## Suggested Agent Language

When explaining fingerprinting to the user, prefer language like:

- "This raises the cost of repeat signups."
- "This is a practical anti-abuse control, not perfect fraud detection."
- "We can start with simple per-device limits and tighten later if abuse appears."

Avoid language like:
- "This guarantees one account per human."
- "This completely stops fraud."
- "This uniquely identifies every user."

## Minimal Implementation Pattern

```typescript
async function checkDeviceLimit(visitorId: string) {
  const limit = Number(process.env.MAX_ACCOUNTS_PER_VISITOR_ID || '2');

  const existingAccounts = await db
    .select()
    .from(users)
    .where(eq(users.fingerprintId, visitorId));

  if (existingAccounts.length >= limit) {
    throw new Error('This device has reached the signup limit.');
  }
}
```

Pair this with:
- email uniqueness checks
- IP-based attempt limits
- registration event logging

## When to Escalate Beyond This Reference

If the user asks for any of the following, do not stop at simple fingerprinting:
- behavioral fraud scoring
- adaptive challenges/captcha
- review queues or moderation workflows
- enterprise identity or compliance workflows

In those cases, position SaaS Auth Shield as a lightweight foundation, not a complete fraud platform.
