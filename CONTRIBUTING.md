# Contributing to Orbit

Thanks for helping improve this open-source Rails + Firebase marketplace demo.

## Development setup

1. Ruby 3.4+
2. `cp .env.example .env` and add Firebase web config
3. `bin/setup && bin/rails db:seed`
4. `bin/rails server` (or `bin/dev` if Tailwind watch works in your environment)
5. Open http://localhost:3000 — use **Dev login** without Firebase

## Guidelines

- Keep **Rails** as the source of truth for bookings, money, and reviews
- Keep **Firestore** for live room collaboration only
- Prefer small, focused pull requests
- Add/adjust Minitest coverage for behavior changes
- Do not commit `.env`, credentials, or service-account keys

## Pull requests

1. Branch from `main`
2. Run `bin/rails test`
3. Describe the “why” in the PR body
4. Include screenshots for UI changes when practical

## Code of conduct

Be respectful. See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).
