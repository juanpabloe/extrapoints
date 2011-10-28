class Team < ActiveRecord::Base

  has_many :users, :conditions => {:type => ['Student']}
  belongs_to :group

  attr_accessible :name
end
