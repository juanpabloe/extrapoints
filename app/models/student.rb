class Student < User

  scope :ordered_for_ranking, order("points DESC, first_name ASC")

end
