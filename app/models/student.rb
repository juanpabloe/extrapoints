class Student < User

  scope :ordered, order("points DESC")

  def complete_name
  	 if self.first_name && self.last_name
       self.first_name + " " + self.last_name
    else
       ""
    end
  end

  def self.search(search)
    if search
      find(:all, :conditions => ['first_name LIKE ? OR last_name LIKE ?', "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end

  def self.update_points(id)
    client = Savon::Client.new(MOBILE_MONEY)
    response = client.request :wsdl, :get_state do
      soap.body = "<userId>#{id}</userId>"
    end
    response[:res_message][:balance].to_i
  end
end
