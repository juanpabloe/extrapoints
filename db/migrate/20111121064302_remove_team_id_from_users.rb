class RemoveTeamIdFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :team_id
    remove_column :users, :group_id
  end

  def down
    add_column :users, :team_id, :integer
    add_column :users, :group_id, :integer
  end
end
