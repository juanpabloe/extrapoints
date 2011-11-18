class AddAfterBalanceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :after_balance, :integer
  end
end
