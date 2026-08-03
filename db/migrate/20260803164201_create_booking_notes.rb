class CreateBookingNotes < ActiveRecord::Migration[8.1]
  def change
    create_table :booking_notes do |t|
      t.references :booking, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.text :body, null: false

      t.timestamps
    end
    add_index :booking_notes, [ :booking_id, :created_at ]
  end
end
