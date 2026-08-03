class MentorSkill < ApplicationRecord
  belongs_to :mentor_profile
  belongs_to :skill

  validates :skill_id, uniqueness: { scope: :mentor_profile_id }
end
