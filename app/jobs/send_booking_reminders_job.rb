class SendBookingRemindersJob < ApplicationJob
  queue_as :default

  def perform
    Booking.remindable.find_each do |booking|
      BookingMailer.reminder(booking).deliver_later
      Notifications::Notify.call(
        user: booking.learner,
        kind: "session_reminder",
        title: "Session starts soon",
        body: "With #{booking.mentor_user.display_name} at #{booking.starts_at.strftime('%H:%M UTC')}",
        link_path: "/bookings/#{booking.id}/room"
      )
      Notifications::Notify.call(
        user: booking.mentor_user,
        kind: "session_reminder",
        title: "Session starts soon",
        body: "With #{booking.learner.display_name} at #{booking.starts_at.strftime('%H:%M UTC')}",
        link_path: "/bookings/#{booking.id}/room"
      )
      booking.update!(reminder_sent_at: Time.current)
    end
  end
end
