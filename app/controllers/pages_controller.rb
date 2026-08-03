class PagesController < ApplicationController
  def home
    @mentors = MentorProfile.listed.limit(6)
    @skills = Skill.order(:name).limit(12)
  end
end
