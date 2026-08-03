# Security

This is a learning / portfolio project. Don't treat it as hardened production software out of the box.

## Reporting issues

Please don't file public issues for security bugs. Use a private GitHub advisory or email the maintainer with:

- what happened
- how to reproduce it
- how bad it is

## Before you ship this for real

- Lock down Firebase authorized domains
- Deploy the rules in this repo (`firestore.rules`, `storage.rules`)
- Prefer Postgres over SQLite
- Use signed Stripe webhooks
- Turn off `dev_login`
- Rotate any keys that ever leaked
