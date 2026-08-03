# Orbit

**Live skill-session marketplace** — a portfolio Rails app with Firebase Auth, realtime session chat, and optional Stripe Checkout.

Built as a **single codebase** (Rails 8 + Hotwire + Tailwind). Rails owns bookings, money, and authorization. Firebase owns identity and live chat/presence.

## Why this stack

| Concern | System | Why |
|--------|--------|-----|
| Profiles, slots, bookings, reviews | Rails + SQLite (Postgres-ready) | Strong domain modeling for interviews |
| Sign-in | Firebase Auth → Rails session | Modern auth without rolling your own |
| Session chat + presence | Firebase Realtime Database | Realtime without Action Cable complexity |
| Payments | Stripe Checkout | Real marketplace signal |
| AuthZ | Pundit | Standard Rails hiring expectation |

## Quick start

```bash
# Ruby 3.4+ (Homebrew: /opt/homebrew/opt/ruby/bin)
cp .env.example .env
bin/setup
bin/rails db:seed
bin/dev
```

Open [http://localhost:3000](http://localhost:3000).

### Demo without Firebase

1. Open the home page  
2. Use **Dev login** (development only) as `Jordan Lee` (learner) or a mentor  
3. Browse mentors → book a slot → open the **Live room**

Without Stripe keys, bookings confirm immediately (great for demos).

### Wire Firebase

1. Create a Firebase project  
2. Enable **Google** sign-in  
3. Create a **Realtime Database**  
4. Copy web config values into `.env`  
5. Restart `bin/dev`  
6. Use **Sign in** in the nav  

Suggested Realtime Database rules for demos (tighten for production):

```json
{
  "rules": {
    "bookings": {
      "$bookingId": {
        ".read": "auth != null",
        ".write": "auth != null"
      }
    }
  }
}
```

### Wire Stripe (optional)

Set `STRIPE_SECRET_KEY`, `STRIPE_PUBLISHABLE_KEY`, and optionally `STRIPE_WEBHOOK_SECRET`.  
Webhook endpoint: `POST /stripe/webhook` for `checkout.session.completed`.

## App map

```
app/
  models/           User, MentorProfile, AvailabilitySlot, Booking, Review, Skill
  services/
    firebase/       ID token verification (JWKS)
    users/          Find-or-create from Firebase claims
    bookings/       Reserve slot + create booking
    payments/       Stripe Checkout session
  controllers/      Marketplace + mentor HQ + session rooms
  javascript/controllers/
    firebase_auth_controller.js
    session_chat_controller.js
```

### Main flows

1. **Sign in** — Firebase ID token verified in `SessionsController`  
2. **Become a mentor** — profile + skills + availability slots  
3. **Book** — `Bookings::Create` reserves the slot; Stripe if configured  
4. **Live room** — Firebase chat at `booking.firebase_chat_path`

## Portfolio talking points

- Clear boundary: **Rails = source of truth for money/bookings**, **Firebase = live collaboration**  
- Service objects + Pundit policies  
- Idempotent-ish slot reservation to prevent double booking  
- Dev login path so reviewers can try the product in under a minute  

## Next upgrades (great resume commits)

- [ ] Review form after `completed` bookings  
- [ ] Solid Queue reminder emails 15 minutes before session  
- [ ] Firebase Storage for session attachments  
- [ ] FCM push notifications  
- [ ] Switch development DB to PostgreSQL  
- [ ] RSpec request specs for booking + auth bridge  

## License

MIT — use this freely in your portfolio.
