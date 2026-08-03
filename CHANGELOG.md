# Changelog

## Unreleased

### Added
- Firestore live rooms (chat, presence, typing, attachments)
- Booking cancel / complete lifecycle + ICS download
- Reviews, favorites, private booking notes, in-app notifications
- Mentor search / filters / sort
- Admin dashboard for users, bookings, mentor listings
- Solid Queue reminder job + booking mailers
- Open-source docs, MIT license, Firebase rules package
- Minitest coverage for booking, search, auth bridge

### Changed
- Replaced Realtime Database chat with Cloud Firestore
- Booking rooms keyed as `bookings/{id}`
