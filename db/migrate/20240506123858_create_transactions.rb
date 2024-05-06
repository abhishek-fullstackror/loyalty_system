class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :country, null: false

      t.timestamps
    end
  end
end
