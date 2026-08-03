class CreateMentorProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :mentor_profiles do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :headline, null: false
      t.text :bio
      t.integer :hourly_rate_cents, null: false, default: 5000
      t.string :currency, null: false, default: "usd"
      t.boolean :active, null: false, default: true
      t.integer :years_experience, default: 0

      t.timestamps
    end
  end
end
