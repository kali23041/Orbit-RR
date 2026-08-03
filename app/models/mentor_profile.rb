class MentorProfile < ApplicationRecord
  belongs_to :user
  has_many :mentor_skills, dependent: :destroy
  has_many :skills, through: :mentor_skills
  has_many :availability_slots, dependent: :destroy
  has_many :bookings, dependent: :restrict_with_exception
  has_many :reviews, through: :bookings
  has_many :favorites, dependent: :destroy

  validates :headline, :hourly_rate_cents, :currency, presence: true
  validates :hourly_rate_cents, numericality: { greater_than: 0 }
  validates :user_id, uniqueness: true

  scope :listed, -> { where(active: true).includes(:user, :skills) }

  def self.search(q: nil, skill: nil, max_price_cents: nil, sort: "newest")
    scope = listed
    if q.present?
      term = "%#{ActiveRecord::Base.sanitize_sql_like(q.to_s.strip)}%"
      scope = scope.joins(:user).where(
        "users.name LIKE ? OR mentor_profiles.headline LIKE ? OR mentor_profiles.bio LIKE ?",
        term, term, term
      )
    end
    scope = scope.joins(:skills).where(skills: { slug: skill }).distinct if skill.present?
    scope = scope.where("hourly_rate_cents <= ?", max_price_cents.to_i) if max_price_cents.present?

    case sort.to_s
    when "rate"
      scope.order(hourly_rate_cents: :asc)
    when "rating"
      scope.left_joins(:reviews)
        .select("mentor_profiles.*, AVG(reviews.rating) AS avg_rating")
        .group("mentor_profiles.id")
        .order(Arel.sql("AVG(reviews.rating) DESC"))
    else
      scope.order(created_at: :desc)
    end
  end

  def hourly_rate
    hourly_rate_cents / 100.0
  end

  def average_rating
    ratings = reviews.pluck(:rating)
    return nil if ratings.empty?

    (ratings.sum.to_f / ratings.size).round(1)
  end

  def reviews_count
    reviews.count
  end

  def upcoming_open_slots
    availability_slots.open.upcoming.order(:starts_at)
  end
end
