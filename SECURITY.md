# Security Policy

## Supported versions

This is an educational / portfolio open-source app. Use at your own risk in production.

## Reporting a vulnerability

Please **do not** open a public issue for security problems.

Email the maintainer or open a private GitHub security advisory with:

- Description of the issue
- Steps to reproduce
- Impact assessment

## Hardening checklist before production

- Restrict Firebase Auth authorized domains
- Deploy strict [`firestore.rules`](firestore.rules) and [`storage.rules`](storage.rules)
- Use PostgreSQL instead of SQLite
- Configure Stripe webhooks with signing secrets
- Remove development `dev_login` routes
- Rotate any keys that were ever committed or shared publicly
