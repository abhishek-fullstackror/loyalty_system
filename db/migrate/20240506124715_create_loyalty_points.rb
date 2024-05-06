class CreateLoyaltyPoints < ActiveRecord::Migration[7.1]
  def change
    create_table :loyalty_points do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :points, default: 0, null: false

      t.timestamps
    end
  end
end
