class Student < User

  belongs_to :team, :class_name => "Team"
  
  belongs_to :group, :class_name => "User"
  
  attr_accessible :group_id,:team_id

  scope :ordered_for_ranking, order("points DESC, first_name ASC")

end
