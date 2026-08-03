module Mentor
  class DashboardsController < BaseController
    def show
      @slots = mentor_profile.availability_slots.upcoming.order(:starts_at).limit(20)
      @bookings = mentor_profile.bookings.includes(:learner, :availability_slot).order(created_at: :desc).limit(20)
    end
  end
end
