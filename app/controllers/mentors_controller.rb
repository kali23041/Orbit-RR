class MentorsController < ApplicationController
  def index
    @skills = Skill.order(:name)
    @q = params[:q]
    @skill = params[:skill]
    @max_price = params[:max_price]
    @sort = params[:sort].presence || "newest"
    max_cents = @max_price.present? ? (@max_price.to_f * 100).to_i : nil

    @mentors = MentorProfile.search(
      q: @q,
      skill: @skill,
      max_price_cents: max_cents,
      sort: @sort
    )
  end

  def show
    @mentor = MentorProfile.listed.find(params[:id])
    @slots = @mentor.upcoming_open_slots.limit(12)
    @reviews = Review.joins(:booking).where(bookings: { mentor_profile_id: @mentor.id }).includes(:reviewer).order(created_at: :desc).limit(10)
    @favorited = signed_in? && current_user.favorited?(@mentor)
  end
end
