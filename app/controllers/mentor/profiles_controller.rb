module Mentor
  class ProfilesController < ApplicationController
    before_action :require_authentication

    def new
      redirect_to edit_mentor_profile_path and return if current_user.mentor_profile.present?

      @mentor_profile = current_user.build_mentor_profile
      @skills = Skill.order(:name)
    end

    def create
      @mentor_profile = current_user.build_mentor_profile(profile_params)
      @skills = Skill.order(:name)

      if @mentor_profile.save
        sync_skills
        current_user.mentor! unless current_user.admin?
        redirect_to mentor_dashboard_path, notice: "Mentor profile published."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @mentor_profile = current_user.mentor_profile
      redirect_to new_mentor_profile_path and return unless @mentor_profile

      @skills = Skill.order(:name)
    end

    def update
      @mentor_profile = current_user.mentor_profile
      @skills = Skill.order(:name)

      if @mentor_profile.update(profile_params)
        sync_skills
        redirect_to mentor_dashboard_path, notice: "Profile updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def profile_params
      params.require(:mentor_profile).permit(
        :headline, :bio, :hourly_rate_cents, :currency, :active, :years_experience
      )
    end

    def sync_skills
      skill_ids = Array(params.dig(:mentor_profile, :skill_ids)).reject(&:blank?).map(&:to_i)
      @mentor_profile.skill_ids = skill_ids
    end
  end
end
