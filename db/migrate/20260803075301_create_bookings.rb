class CreateBookings < ActiveRecord::Migration[8.1]
  def change
    create_table :bookings do |t|
      t.references :learner, null: false, foreign_key: { to_table: :users }
      t.references :mentor_profile, null: false, foreign_key: true
      t.references :availability_slot, null: false, foreign_key: true, index: { unique: true }
      t.integer :status, null: false, default: 0
      t.integer :amount_cents, null: false
      t.string :currency, null: false, default: "usd"
      t.string :stripe_checkout_session_id
      t.string :stripe_payment_intent_id
      t.string :meet_url
      t.string :firebase_chat_path
      t.text :notes

      t.timestamps
    end
    add_index :bookings, :stripe_checkout_session_id, unique: true
  end
end
