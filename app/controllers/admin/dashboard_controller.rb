module Admin
  class DashboardController < BaseController
    def show
      @users_count = User.count
      @bookings_count = Booking.count
      @mentors_count = MentorProfile.count
      @active_mentors = MentorProfile.where(active: true).count
      @recent_bookings = Booking.includes(:learner, mentor_profile: :user).order(created_at: :desc).limit(8)
    end
  end
end
