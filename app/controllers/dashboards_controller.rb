class DashboardsController < ApplicationController
  before_action :require_authentication

  def show
    @learner_bookings = current_user.bookings_as_learner.includes(mentor_profile: :user, availability_slot: {}).order(created_at: :desc).limit(10)
    @mentor_profile = current_user.mentor_profile
    @mentor_bookings = if @mentor_profile
      @mentor_profile.bookings.includes(:learner, :availability_slot).order(created_at: :desc).limit(10)
    else
      Booking.none
    end
  end
end
