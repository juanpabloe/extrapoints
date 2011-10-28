class AddGroupToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :group_id, :integer
  end
end
