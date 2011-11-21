class RemoveDonationsAndWithdraws < ActiveRecord::Migration
  def up
    drop_table :donations
    drop_table :withdraws
  end

  def down
    create_table "withdraws" do |t|
      t.timestamps
    end
    create_table "donations" do |t|
      t.timestamps
    end
  end
end
