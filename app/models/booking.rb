class Booking < ApplicationRecord
  enum :status, {
    pending_payment: 0,
    confirmed: 1,
    completed: 2,
    cancelled: 3,
    refunded: 4
  }, default: :pending_payment

  belongs_to :learner, class_name: "User"
  belongs_to :mentor_profile
  belongs_to :availability_slot
  has_one :review, dependent: :destroy

  validates :amount_cents, :currency, :firebase_chat_path, presence: true
  validates :availability_slot_id, uniqueness: true
  validates :amount_cents, numericality: { greater_than: 0 }

  before_validation :assign_chat_path, on: :create

  scope :for_learner, ->(user) { where(learner: user) }
  scope :for_mentor, ->(profile) { where(mentor_profile: profile) }

  def mentor_user
    mentor_profile.user
  end

  def starts_at
    availability_slot.starts_at
  end

  def ends_at
    availability_slot.ends_at
  end

  def confirm!
    transaction do
      update!(status: :confirmed)
      availability_slot.booked!
    end
  end

  def complete!
    update!(status: :completed)
  end

  private

  def assign_chat_path
    self.firebase_chat_path ||= "bookings/#{SecureRandom.uuid}/messages"
  end
end
