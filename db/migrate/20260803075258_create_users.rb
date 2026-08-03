class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :firebase_uid, null: false
      t.string :email, null: false
      t.string :name, null: false
      t.string :avatar_url
      t.integer :role, null: false, default: 0
      t.string :timezone, default: "UTC"

      t.timestamps
    end
    add_index :users, :firebase_uid, unique: true
    add_index :users, :email, unique: true
  end
end
