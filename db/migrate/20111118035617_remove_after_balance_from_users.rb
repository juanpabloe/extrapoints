class RemoveAfterBalanceFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :after_balance
  end

  def down
    add_column :users, :after_balance
  end
end
