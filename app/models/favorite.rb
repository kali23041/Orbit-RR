class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :mentor_profile

  validates :mentor_profile_id, uniqueness: { scope: :user_id }
  validate :cannot_favorite_self

  private

  def cannot_favorite_self
    return if user.blank? || mentor_profile.blank?
    return if mentor_profile.user_id != user_id

    errors.add(:mentor_profile, "cannot favorite yourself")
  end
end
