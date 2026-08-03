class ReviewPolicy < ApplicationPolicy
  def create?
    return false unless user
    return false unless record.booking.completed?
    return false if Review.exists?(booking_id: record.booking_id)

    record.booking.learner_id == user.id
  end
end
