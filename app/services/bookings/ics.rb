# frozen_string_literal: true

module Bookings
  class Ics
    def self.call(booking)
      new(booking).call
    end

    def initialize(booking)
      @booking = booking
    end

    def call
      uid = "orbit-booking-#{booking.id}@orbit.dev"
      <<~ICS
        BEGIN:VCALENDAR
        VERSION:2.0
        PRODID:-//Orbit//Skill Sessions//EN
        CALSCALE:GREGORIAN
        METHOD:PUBLISH
        BEGIN:VEVENT
        UID:#{uid}
        DTSTAMP:#{utc(Time.current)}
        DTSTART:#{utc(booking.starts_at)}
        DTEND:#{utc(booking.ends_at)}
        SUMMARY:Orbit session with #{booking.mentor_user.display_name}
        DESCRIPTION:Meet link: #{booking.meet_url}\\nRoom: #{booking.firestore_room_id}
        URL:#{booking.meet_url}
        END:VEVENT
        END:VCALENDAR
      ICS
    end

    private

    attr_reader :booking

    def utc(time)
      time.utc.strftime("%Y%m%dT%H%M%SZ")
    end
  end
end
