# Firestore

Bookings live in Rails. Firestore is just the live room for a booking (`rooms/{bookingId}`).

## Collections

```text
rooms/{bookingId}
  learnerUid, mentorUid, railsBookingId, status, updatedAt

rooms/{bookingId}/messages/{messageId}
  text, senderUid, senderName, type (text|system|file),
  attachmentPath?, attachmentName?, attachmentUrl?, createdAt

rooms/{bookingId}/presence/{uid}
  displayName, online, lastActiveAt

rooms/{bookingId}/typing/{uid}
  isTyping, displayName, updatedAt

user_public/{uid}
  displayName, photoURL?, role, updatedAt
```

## Storage

```text
rooms/{bookingId}/attachments/{filename}
```

## Deploy rules

```bash
npm install -g firebase-tools
firebase login
firebase use your-project-id
firebase deploy --only firestore:rules,storage
```

Repo files: `firestore.rules`, `storage.rules`, `firestore.indexes.json`, `firebase.json`.

## Auth domain

In Firebase → Authentication → Settings → Authorized domains, use:

```text
localhost
```

Don't add `127.0.0.1:3000`. Open the app at http://localhost:3000 when testing Google sign-in.

## Heads-up for Dev login

Seed users have fake Firebase UIDs (`seed-learner-1`, etc.). Real Firestore rules expect matching Auth UIDs, so Dev Login chats may get permission errors unless you loosen rules for local demos or sign in with real Google accounts.
