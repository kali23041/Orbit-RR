class UpgradeBookingsForFirestore < ActiveRecord::Migration[8.1]
  def up
    add_column :bookings, :firestore_room_id, :string
    add_column :bookings, :reminder_sent_at, :datetime
    add_index :bookings, :firestore_room_id, unique: true

    # Backfill from legacy chat path / booking id
    say_with_time "backfill firestore_room_id" do
      Booking.reset_column_information
      Booking.find_each do |booking|
        room_id = booking.firestore_room_id.presence || "bookings/#{booking.id}"
        booking.update_columns(firestore_room_id: room_id)
      end
    end

    change_column_null :bookings, :firestore_room_id, false
  end

  def down
    remove_index :bookings, :firestore_room_id
    remove_column :bookings, :firestore_room_id
    remove_column :bookings, :reminder_sent_at
  end
end
