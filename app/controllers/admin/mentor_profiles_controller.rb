module Admin
  class MentorProfilesController < BaseController
    def index
      @mentors = MentorProfile.includes(:user).order(created_at: :desc)
    end

    def update
      mentor = MentorProfile.find(params[:id])
      mentor.update!(active: ActiveModel::Type::Boolean.new.cast(params[:active]))
      redirect_to admin_mentor_profiles_path, notice: "Mentor listing updated."
    end
  end
end
