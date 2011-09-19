class AddForeignKeysToOperation < ActiveRecord::Migration
  def change
    add_column :operations, :from_user_id, :integer
    add_column :operations, :to_user_id, :integer
  end
end
