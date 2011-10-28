class Group < ActiveRecord::Base
	has_many :users, :conditions => {:type => ['Student']}
	has_many :teams
	
  attr_accessible :subject, :classCode, :number
end
