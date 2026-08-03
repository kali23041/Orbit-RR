module Mentor
  class BaseController < ApplicationController
    before_action :require_authentication
    before_action :require_mentor_profile

    private

    def require_mentor_profile
      return if current_user.mentor_profile.present?

      redirect_to new_mentor_profile_path, alert: "Create your mentor profile first."
    end

    def mentor_profile
      @mentor_profile ||= current_user.mentor_profile
    end
    helper_method :mentor_profile
  end
end
