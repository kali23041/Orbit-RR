# Firestore data model

Rails remains the source of truth for bookings. Firestore stores **ephemeral collaboration** for a room keyed by booking id.

## Collections

```text
rooms/{bookingId}
  learnerUid: string
  mentorUid: string
  railsBookingId: string
  status: string
  updatedAt: timestamp

rooms/{bookingId}/messages/{messageId}
  text: string
  senderUid: string
  senderName: string
  type: "text" | "system" | "file"
  attachmentPath?: string
  attachmentName?: string
  attachmentUrl?: string
  createdAt: timestamp

rooms/{bookingId}/presence/{uid}
  displayName: string
  online: boolean
  lastActiveAt: timestamp

rooms/{bookingId}/typing/{uid}
  isTyping: boolean
  displayName: string
  updatedAt: timestamp

user_public/{uid}
  displayName: string
  photoURL?: string
  role: string
  updatedAt: timestamp
```

## Storage

```text
rooms/{bookingId}/attachments/{filename}
```

## Deploy rules

```bash
npm install -g firebase-tools
firebase login
firebase use rubyrail-c1bda   # or your project
firebase deploy --only firestore:rules,storage
```

Files in this repo:

- [`../firestore.rules`](../firestore.rules)
- [`../storage.rules`](../storage.rules)
- [`../firestore.indexes.json`](../firestore.indexes.json)
- [`../firebase.json`](../firebase.json)

## Auth domain note

In Firebase Console → Authentication → Settings → Authorized domains, add:

```text
localhost
```

Do **not** add `127.0.0.1:3000`. Open the app at http://localhost:3000 when testing Google sign-in.

## Demo rules warning

The shipped rules require room membership based on `learnerUid` / `mentorUid`. Seed users use fake Firebase UIDs (`seed-learner-1`, etc.), so Firestore writes from Dev Login will be denied unless you relax rules for demos or sign in with real Firebase Auth users whose UIDs match the Rails `users.firebase_uid` values.
