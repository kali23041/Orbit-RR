module Admin
  class BookingsController < BaseController
    def index
      @bookings = Booking.includes(:learner, mentor_profile: :user, availability_slot: {}).order(created_at: :desc).limit(100)
    end
  end
end
