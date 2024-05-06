class AddColumnsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :free_coffee_reward, :boolean, default: false
    add_column :users, :birthday_month, :string
  end
end
