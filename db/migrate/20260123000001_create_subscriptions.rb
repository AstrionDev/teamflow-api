class CreateSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :subscriptions do |t|
      t.references :organization, null: false, foreign_key: true, index: { unique: true }
      t.string :plan_name, null: false, default: "free"
      t.string :status, null: false, default: "active"
      t.json :limits
      t.datetime :current_period_ends_at
      t.timestamps
    end
  end
end
