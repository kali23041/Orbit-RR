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
  has_many :booking_notes, dependent: :destroy

  validates :amount_cents, :currency, :firestore_room_id, presence: true
  validates :availability_slot_id, uniqueness: true
  validates :firestore_room_id, uniqueness: true
  validates :amount_cents, numericality: { greater_than: 0 }

  before_validation :assign_firestore_room_id, on: :create
  after_create :finalize_firestore_room_id

  scope :for_learner, ->(user) { where(learner: user) }
  scope :for_mentor, ->(profile) { where(mentor_profile: profile) }
  scope :remindable, -> {
    confirmed
      .where(reminder_sent_at: nil)
      .joins(:availability_slot)
      .where(availability_slots: { starts_at: Time.current..15.minutes.from_now })
  }

  def mentor_user
    mentor_profile.user
  end

  def starts_at
    availability_slot.starts_at
  end

  def ends_at
    availability_slot.ends_at
  end

  def participant?(user)
    return false unless user

    learner_id == user.id || mentor_profile.user_id == user.id || user.admin?
  end

  def cancellable?
    pending_payment? || confirmed?
  end

  def completable?
    confirmed? && ends_at <= Time.current
  end

  def confirm!
    transaction do
      update!(status: :confirmed)
      availability_slot.booked! unless availability_slot.booked?
    end
  end

  def complete!
    raise "Booking cannot be completed" unless confirmed?

    update!(status: :completed)
  end

  def cancel!
    raise "Booking cannot be cancelled" unless cancellable?

    transaction do
      update!(status: :cancelled)
      availability_slot.open! if availability_slot.booked?
    end
  end

  def firebase_chat_path
    firestore_room_id
  end

  private

  def assign_firestore_room_id
    self.firestore_room_id ||= "bookings/pending-#{SecureRandom.uuid}"
  end

  def finalize_firestore_room_id
    desired = "bookings/#{id}"
    update_column(:firestore_room_id, desired) if firestore_room_id != desired
  end
end
