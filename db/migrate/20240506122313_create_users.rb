class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, limit: 255
      t.string :name, limit: 255

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end