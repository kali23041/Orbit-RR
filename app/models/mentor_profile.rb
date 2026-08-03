class MentorProfile < ApplicationRecord
  belongs_to :user
  has_many :mentor_skills, dependent: :destroy
  has_many :skills, through: :mentor_skills
  has_many :availability_slots, dependent: :destroy
  has_many :bookings, dependent: :restrict_with_exception
  has_many :reviews, through: :bookings

  validates :headline, :hourly_rate_cents, :currency, presence: true
  validates :hourly_rate_cents, numericality: { greater_than: 0 }
  validates :user_id, uniqueness: true

  scope :listed, -> { where(active: true).includes(:user, :skills) }

  def hourly_rate
    hourly_rate_cents / 100.0
  end

  def average_rating
    ratings = reviews.pluck(:rating)
    return nil if ratings.empty?

    (ratings.sum.to_f / ratings.size).round(1)
  end

  def upcoming_open_slots
    availability_slots.open.upcoming.order(:starts_at)
  end
end
