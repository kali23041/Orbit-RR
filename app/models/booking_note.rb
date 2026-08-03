class BookingNote < ApplicationRecord
  belongs_to :booking
  belongs_to :author, class_name: "User"

  validates :body, presence: true, length: { maximum: 5000 }
  validate :author_must_be_participant

  private

  def author_must_be_participant
    return if booking.blank? || author.blank?
    return if booking.participant?(author)

    errors.add(:author, "must be a booking participant")
  end
end
