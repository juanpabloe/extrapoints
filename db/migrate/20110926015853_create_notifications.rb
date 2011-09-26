class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :concept
      t.integer :user_id

      t.timestamps
    end
  end
end
