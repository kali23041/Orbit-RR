class CreateMentorSkills < ActiveRecord::Migration[8.1]
  def change
    create_table :mentor_skills do |t|
      t.references :mentor_profile, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true

      t.timestamps
    end
    add_index :mentor_skills, [ :mentor_profile_id, :skill_id ], unique: true
  end
end
