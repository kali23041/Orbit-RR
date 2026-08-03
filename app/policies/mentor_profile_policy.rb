class MentorProfilePolicy < ApplicationPolicy
  def book?
    user.present? && record.user_id != user.id && record.active?
  end
end
