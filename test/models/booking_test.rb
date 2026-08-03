require "test_helper"

class BookingTest < ActiveSupport::TestCase
  setup do
    @learner = User.create!(firebase_uid: "uid-learner", email: "learner@test.dev", name: "Learner")
    @mentor_user = User.create!(firebase_uid: "uid-mentor", email: "mentor@test.dev", name: "Mentor", role: :mentor)
    @profile = MentorProfile.create!(user: @mentor_user, headline: "Rails mentor", hourly_rate_cents: 8000, bio: "Bio")
    @slot = @profile.availability_slots.create!(
      starts_at: 2.days.from_now,
      ends_at: 2.days.from_now + 45.minutes,
      status: :open
    )
  end

  test "create reserves slot and assigns firestore room" do
    booking = Bookings::Create.call(learner: @learner, slot: @slot)
    assert booking.confirmed?
    assert_equal "bookings/#{booking.id}", booking.firestore_room_id
    assert @slot.reload.booked?
  end

  test "cancel releases slot" do
    booking = Bookings::Create.call(learner: @learner, slot: @slot)
    Bookings::Cancel.call(booking: booking, actor: @learner)
    assert booking.reload.cancelled?
    assert @slot.reload.open?
  end

  test "complete allows review" do
    booking = Bookings::Create.call(learner: @learner, slot: @slot)
    Bookings::Complete.call(booking: booking, actor: @mentor_user)
    review = booking.reload.build_review(reviewer: @learner, rating: 5, body: "Great")
    assert review.valid?
    assert review.save
  end
end
