class CreateAvailabilitySlots < ActiveRecord::Migration[8.1]
  def change
    create_table :availability_slots do |t|
      t.references :mentor_profile, null: false, foreign_key: true
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
    add_index :availability_slots, [ :mentor_profile_id, :starts_at ]
  end
end
