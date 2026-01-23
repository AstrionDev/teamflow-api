class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :kind, null: false
      t.text :message
      t.json :metadata
      t.string :status, null: false, default: "pending"
      t.datetime :delivered_at
      t.datetime :read_at
      t.timestamps
    end

    add_index :notifications, :status
  end
end
