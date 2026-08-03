# Architecture

Orbit is a **single Rails 8 codebase** that demonstrates a clean split between transactional domain data and realtime collaboration.

## System split

| Concern | System | Why |
|--------|--------|-----|
| Users, mentors, slots, bookings, reviews, favorites, notes | Rails + SQLite (Postgres-ready) | Strong domain modeling, Pundit, money |
| Identity | Firebase Auth → Rails session | Modern auth without rolling password storage |
| Live room chat / presence / typing | Cloud Firestore | Member-scoped realtime collaboration |
| Attachments | Firebase Storage | Files beside room messages |
| Payments | Stripe Checkout (optional) | Marketplace signal; demos work without keys |
| Reminders | Solid Queue + Action Mailer | Background jobs without Redis |

## Request flows

### Sign-in
1. Browser signs in with Firebase Google popup
2. Client posts ID token to `POST /session`
3. Rails verifies token via Google JWKS (`Firebase::IdTokenVerifier`)
4. `Users::FindOrCreateFromFirebase` upserts the user and stores `session[:user_id]`

### Booking
1. Learner books an open `AvailabilitySlot`
2. `Bookings::Create` reserves the slot and creates a booking with `firestore_room_id = bookings/{id}`
3. Optional Stripe Checkout; otherwise booking is confirmed immediately
4. Mentor receives an in-app notification

### Live room
1. Rails authorizes participants and renders membership UIDs
2. Client creates/merges Firestore `rooms/{id}` with learner/mentor UIDs
3. Messages / presence / typing live under that room document
4. Private session notes stay in Rails (`booking_notes`)

## ERD (simplified)

```text
User 1─1 MentorProfile 1─* AvailabilitySlot
User 1─* Booking(as learner)
MentorProfile 1─* Booking
Booking 1─1 Review
Booking 1─* BookingNote
User 1─* Favorite *─1 MentorProfile
User 1─* Notification
```

## Key paths

- `app/models` — domain
- `app/services` — booking lifecycle, payments, notifications
- `app/javascript/firebase` — shared Firebase bootstrap
- `app/javascript/controllers` — Stimulus (auth + Firestore room)
- `firestore.rules` / `storage.rules` — security rules for OSS deploy

---

Designed & built by [Kartik Sabale](https://kartiksabale.com).
