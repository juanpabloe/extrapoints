class Student < User

  belongs_to :team, :class_name => "Team"
  
  belongs_to :group, :class_name => "User"
  
  attr_accessible :group_id,:team_id

  scope :ordered, order("points DESC, first_name ASC")

  def self.search(search)
    if search
      find(:all, :conditions => ["first_name #{LIKE} ? OR last_name #{LIKE} ?", "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end
  
  

end
