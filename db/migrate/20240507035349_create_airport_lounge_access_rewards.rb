class CreateAirportLoungeAccessRewards < ActiveRecord::Migration[7.1]
  def change
    create_table :airport_lounge_access_rewards do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :reward_type

      t.timestamps
    end
  end
end
