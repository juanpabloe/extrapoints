class CreatePretransactions < ActiveRecord::Migration
  def change
    create_table :pretransactions do |t|
      t.integer :transaction_id
      t.integer :amount
      t.integer :user_pin
      t.integer :user_id

      t.timestamps
    end
  end
end
