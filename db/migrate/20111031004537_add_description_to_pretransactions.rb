class AddDescriptionToPretransactions < ActiveRecord::Migration
  def change
    add_column :pretransactions, :description, :text
    add_column :pretransactions, :from_user, :integer
  end
end
