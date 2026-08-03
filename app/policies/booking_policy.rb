class BookingPolicy < ApplicationPolicy
  def show?
    return false unless user

    user.admin? || record.learner_id == user.id || record.mentor_profile.user_id == user.id
  end
end
