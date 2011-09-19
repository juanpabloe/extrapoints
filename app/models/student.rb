class Student < User

  scope :ordered, order("points DESC")

  def complete_name
    self.first_name + " " + self.last_name
  end
end
