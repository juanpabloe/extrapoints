class RemoveTypeFromOperations < ActiveRecord::Migration
  def up
    remove_column :operations, :type
    add_column :operations, :op_type, :string
  end

  def down
    add_column :operations, :type, :string
    remove_column :operations, :op_type
  end
end
