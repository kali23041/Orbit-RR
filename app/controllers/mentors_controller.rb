class MentorsController < ApplicationController
  def index
    @skills = Skill.order(:name)
    @mentors = MentorProfile.listed
    @mentors = @mentors.joins(:skills).where(skills: { slug: params[:skill] }) if params[:skill].present?
    @mentors = @mentors.distinct
  end

  def show
    @mentor = MentorProfile.listed.find(params[:id])
    @slots = @mentor.upcoming_open_slots.limit(12)
    @reviews = Review.joins(:booking).where(bookings: { mentor_profile_id: @mentor.id }).includes(:reviewer).order(created_at: :desc).limit(10)
  end
end
