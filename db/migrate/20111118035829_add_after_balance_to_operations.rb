class AddAfterBalanceToOperations < ActiveRecord::Migration
  def change
    add_column :operations, :after_balance, :integer
  end
end
