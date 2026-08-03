# Architecture

Rails holds the real data (users, bookings, money). Firestore is only for the live room while a session is going on.

## Who does what

| Thing | Where |
|--------|--------|
| Mentors, slots, bookings, reviews, favorites, notes | Rails + SQLite (or Postgres) |
| Sign-in | Firebase Auth, then a Rails session |
| Chat / presence / typing | Firestore |
| File uploads in chat | Firebase Storage |
| Payments | Stripe Checkout if configured |
| Reminders | Solid Queue + mailers |

## Sign-in

1. Google popup via Firebase
2. Browser posts the ID token to `POST /session`
3. Rails checks it (`Firebase::IdTokenVerifier`)
4. User is created/updated and `session[:user_id]` is set

## Booking

1. Learner picks an open slot
2. `Bookings::Create` locks the slot and sets `firestore_room_id` to `bookings/{id}`
3. Stripe if keys exist; otherwise it's confirmed right away
4. Mentor gets a notification

## Live room

1. Rails makes sure both people belong on the booking
2. Client writes/merges `rooms/{id}` with their Firebase UIDs
3. Messages, presence, typing live under that room
4. Private notes stay in Rails (`booking_notes`)

## Rough ERD

```text
User 1─1 MentorProfile 1─* AvailabilitySlot
User 1─* Booking (learner)
MentorProfile 1─* Booking
Booking 1─1 Review
Booking 1─* BookingNote
User 1─* Favorite *─1 MentorProfile
User 1─* Notification
```

## Where to look

- `app/models`
- `app/services`
- `app/javascript/firebase`
- `app/javascript/controllers`
- `firestore.rules` / `storage.rules`

Made by [Kartik Sabale](https://kartiksabale.com).
