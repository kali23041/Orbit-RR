class Skill < ApplicationRecord
  has_many :mentor_skills, dependent: :destroy
  has_many :mentor_profiles, through: :mentor_skills

  validates :name, :slug, presence: true, uniqueness: true

  before_validation :assign_slug, on: :create

  private

  def assign_slug
    self.slug = name.to_s.parameterize if slug.blank? && name.present?
  end
end
