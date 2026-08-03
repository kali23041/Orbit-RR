class AvailabilitySlot < ApplicationRecord
  enum :status, { open: 0, booked: 1, blocked: 2 }, default: :open

  belongs_to :mentor_profile
  has_one :booking, dependent: :restrict_with_exception

  validates :starts_at, :ends_at, presence: true
  validate :ends_after_starts

  scope :upcoming, -> { where("starts_at > ?", Time.current) }
  scope :bookable, -> { open.upcoming }

  def duration_minutes
    ((ends_at - starts_at) / 60).to_i
  end

  private

  def ends_after_starts
    return if starts_at.blank? || ends_at.blank?
    return if ends_at > starts_at

    errors.add(:ends_at, "must be after start time")
  end
end
