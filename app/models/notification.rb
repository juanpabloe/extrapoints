class Notification < ActiveRecord::Base
  
  belongs_to :user

  attr_accessible :concept
end
