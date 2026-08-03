class User < ApplicationRecord
  enum :role, { learner: 0, mentor: 1, admin: 2 }, default: :learner

  has_one :mentor_profile, dependent: :destroy
  has_many :bookings_as_learner, class_name: "Booking", foreign_key: :learner_id, inverse_of: :learner, dependent: :restrict_with_exception
  has_many :reviews_written, class_name: "Review", foreign_key: :reviewer_id, inverse_of: :reviewer, dependent: :destroy

  validates :firebase_uid, :email, :name, presence: true
  validates :firebase_uid, :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  def display_name
    name.presence || email.split("@").first
  end

  def mentoring?
    mentor_profile.present?
  end
end
