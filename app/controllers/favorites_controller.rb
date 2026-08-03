class FavoritesController < ApplicationController
  before_action :require_authentication

  def create
    mentor = MentorProfile.listed.find(params[:mentor_id])
    favorite = current_user.favorites.find_or_initialize_by(mentor_profile: mentor)
    authorize favorite
    favorite.save!
    redirect_back fallback_location: mentor_path(mentor), notice: "Saved to favorites."
  end

  def destroy
    mentor = MentorProfile.find(params[:mentor_id])
    favorite = current_user.favorites.find_by!(mentor_profile: mentor)
    authorize favorite
    favorite.destroy!
    redirect_back fallback_location: mentor_path(mentor), notice: "Removed from favorites."
  end
end
