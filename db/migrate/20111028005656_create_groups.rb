class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string      :subject
      t.string      :classCode
      t.integer     :number
      t.timestamps
    end
  end
end
