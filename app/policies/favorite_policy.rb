class FavoritePolicy < ApplicationPolicy
  def create?
    user.present? && record.mentor_profile.user_id != user.id
  end

  def destroy?
    user.present? && record.user_id == user.id
  end
end
