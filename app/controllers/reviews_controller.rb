class ReviewsController < ApplicationController
  before_action :require_authentication

  def create
    booking = Booking.find(params[:booking_id])
    review = booking.build_review(review_params.merge(reviewer: current_user))
    authorize review

    if review.save
      redirect_to booking_path(booking), notice: "Thanks for the review."
    else
      redirect_to booking_path(booking), alert: review.errors.full_messages.to_sentence
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :body)
  end
end
