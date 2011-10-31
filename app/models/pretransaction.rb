class Pretransaction < ActiveRecord::Base

  belongs_to :user

  attr_accessible :transaction_id, :user_id, :amount, :user_pin, :description, :from_user

end
