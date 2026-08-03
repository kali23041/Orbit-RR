require "test_helper"

class BookingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @learner = User.create!(firebase_uid: "l-req", email: "lreq@test.dev", name: "Learner")
    mentor_user = User.create!(firebase_uid: "m-req", email: "mreq@test.dev", name: "Mentor", role: :mentor)
    @profile = MentorProfile.create!(user: mentor_user, headline: "Mentor", hourly_rate_cents: 7000, active: true)
    @slot = @profile.availability_slots.create!(
      starts_at: 3.days.from_now,
      ends_at: 3.days.from_now + 30.minutes,
      status: :open
    )
  end

  test "creates booking when signed in" do
    sign_in_as(@learner)
    assert_difference "Booking.count", 1 do
      post bookings_url, params: { availability_slot_id: @slot.id }
    end
    assert_redirected_to booking_url(Booking.last)
  end

  test "downloads ics" do
    sign_in_as(@learner)
    booking = Bookings::Create.call(learner: @learner, slot: @slot)
    get ics_booking_url(booking)
    assert_response :success
    assert_includes response.body, "BEGIN:VCALENDAR"
  end
end
