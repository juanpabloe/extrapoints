class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|
      t.string :type
      t.integer :amount
      t.text :description

      t.timestamps
    end
  end
end
