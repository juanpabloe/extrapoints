class CreateWithdraws < ActiveRecord::Migration
  def change
    create_table :withdraws do |t|

      t.timestamps
    end
  end
end
