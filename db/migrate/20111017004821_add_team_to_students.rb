class AddTeamToStudents < ActiveRecord::Migration
  def change
    add_column :students, :team_id, :integer
  end
end
