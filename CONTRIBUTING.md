# Contributing

Thanks for poking at Orbit.

## Setup

1. Ruby 3.4+
2. `cp .env.example .env` and drop in Firebase keys if you have them
3. `bin/setup && bin/rails db:seed`
4. `bin/rails server`
5. http://localhost:3000 — Dev login works without Firebase

## Notes

- Put bookings / money / reviews in Rails
- Keep chat stuff in Firestore
- Small PRs are easier to review
- Run `bin/rails test` when you change behavior
- Don't commit `.env` or service account keys

## PRs

1. Branch off `main`
2. `bin/rails test`
3. Say why you changed it
4. Screenshots help for UI tweaks

Be decent — see [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).
