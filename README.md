# Orbit

Rails app for booking short mentorship sessions. Mentors list their skills and availability, learners book a slot, then both jump into a live room (chat + notes + a Meet link).

I built this — [Kartik Sabale](https://kartiksabale.com).

Auth is Firebase (Google). Bookings and payments live in Rails. Chat/presence use Firestore.

## Screenshots

| | |
|---|---|
| ![Home](docs/screenshots/01-home.png) | ![Mentors](docs/screenshots/02-mentors.png) |
| ![Mentor](docs/screenshots/03-mentor-show.png) | ![Dashboard](docs/screenshots/04-dashboard.png) |
| ![Booking](docs/screenshots/05-booking.png) | ![Live room](docs/screenshots/06-live-room.png) |

![Mentor HQ](docs/screenshots/07-mentor-hq.png)

```bash
# optional: refresh screenshots (Chrome + server on :3000)
bin/rails orbit:screenshots
```

## What it does

- Google sign-in (Firebase → Rails session)
- Mentor profiles, skills, open slots
- Book / cancel / complete a session; download an `.ics`
- Stripe Checkout if you set keys (otherwise booking just confirms)
- Reviews, favorites, in-app notifications
- Private notes on a booking (Rails)
- Live room: Firestore chat, who’s online, typing, file uploads
- Search / filter mentors
- Simple admin area
- Reminder emails via Solid Queue

## Stack

Rails 8 + Hotwire + Tailwind. SQLite locally (Postgres is fine later). Firebase Auth, Firestore, Storage. Pundit. Stripe optional.

## Setup

```bash
git clone https://github.com/oraclekartik/RR.git
cd RR
cp .env.example .env
bin/setup
bin/rails db:seed
bin/rails server
```

Open http://localhost:3000

Ruby 3.4+ helps. On macOS Homebrew Ruby is usually at `/opt/homebrew/opt/ruby/bin`.

### Trying it without Firebase

Use **Dev login** on the home page (local only). Book a mentor, open the room. Log in as Orbit Admin for `/admin`.

### Firebase

1. New Firebase project
2. Auth → Google on
3. Create Firestore + Storage
4. Authorized domains: add `localhost` (not `127.0.0.1:3000`)
5. Paste the web config into `.env`
6. Deploy rules:

```bash
firebase deploy --only firestore:rules,storage
```

More detail in [docs/FIRESTORE.md](docs/FIRESTORE.md).

### Stripe (optional)

`STRIPE_SECRET_KEY`, `STRIPE_PUBLISHABLE_KEY`, and maybe `STRIPE_WEBHOOK_SECRET`.  
Webhook endpoint: `POST /stripe/webhook` for `checkout.session.completed`.

## Firestore layout

```text
rooms/{bookingId}
  messages/{id}
  presence/{uid}
  typing/{uid}
user_public/{uid}
```

Files go under `rooms/{bookingId}/attachments/...`  
See [docs/FIRESTORE.md](docs/FIRESTORE.md) and [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Layout of the repo

```text
app/models/
app/services/bookings/
app/services/firebase/
app/javascript/firebase/
app/javascript/controllers/
firestore.rules
storage.rules
docs/
```

## Tests

```bash
bin/rails test
```

## Contributing

[CONTRIBUTING.md](CONTRIBUTING.md) · [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) · [SECURITY.md](SECURITY.md)

## Made by

Kartik Sabale — [kartiksabale.com](https://kartiksabale.com)

## License

[MIT](LICENSE)
