class Review < ApplicationRecord
  belongs_to :booking
  belongs_to :reviewer, class_name: "User"

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :booking_id, uniqueness: true
  validate :booking_must_be_completed

  private

  def booking_must_be_completed
    return if booking&.completed?

    errors.add(:booking, "must be completed before reviewing")
  end
end
