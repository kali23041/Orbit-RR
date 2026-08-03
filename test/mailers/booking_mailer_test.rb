require "test_helper"

class BookingMailerTest < ActionMailer::TestCase
  setup do
    learner = User.create!(firebase_uid: "mail-l", email: "maill@test.dev", name: "Learner")
    mentor = User.create!(firebase_uid: "mail-m", email: "mailm@test.dev", name: "Mentor", role: :mentor)
    profile = MentorProfile.create!(user: mentor, headline: "H", hourly_rate_cents: 5000)
    slot = profile.availability_slots.create!(starts_at: 1.day.from_now, ends_at: 1.day.from_now + 30.minutes, status: :booked)
    @booking = Bookings::Create.call(learner: learner, slot: profile.availability_slots.create!(starts_at: 2.days.from_now, ends_at: 2.days.from_now + 30.minutes, status: :open))
  end

  test "reminder" do
    email = BookingMailer.reminder(@booking)
    assert_emails 1 do
      email.deliver_now
    end
    assert_includes email.subject, "soon"
  end

  test "completed" do
    email = BookingMailer.completed(@booking)
    assert_equal [ @booking.learner.email ], email.to
  end

  test "cancelled" do
    email = BookingMailer.cancelled(@booking)
    assert_includes email.to, @booking.learner.email
  end
end
