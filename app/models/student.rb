class Student < User

  belongs_to :team

  scope :ordered, order("points DESC")

  def self.search(search)
    if search
      find(:all, :conditions => ['first_name LIKE ? OR last_name LIKE ?', "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end
  
  

end
