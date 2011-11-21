class RemoveGroupsAndTeams < ActiveRecord::Migration
  def up
    drop_table :groups
    drop_table :teams
  end
end
