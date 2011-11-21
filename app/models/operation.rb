class Operation < ActiveRecord::Base
  
  belongs_to :from_user, :foreign_key => "from_user_id", :class_name => "User"
  belongs_to :to_user, :foreign_key => "to_user_id", :class_name => "User"

  attr_accessible :amount, :description, :op_type, :to_user_id, :from_user_id, :after_balance

	validates_presence_of :amount
	validates_numericality_of :amount, :greater_than => 0
	validates_presence_of :description

  #scope :all_operations, where("from_user_id = #{current_user.id} OR to_user_id = #{current_user.id}")
	
  #Llamada al webservice "Begin_transfer" de Mobile Money
  def self.new_donation(user_id, amount, pin, receiver)
    client = Savon::Client.new(MOBILE_MONEY)
    response = client.request :wsdl, :begin_transfer do
      soap.body="<userId>#{user_id}</userId><amount>#{amount}</amount><pin>#{pin}</pin><location>0,0</location><imei>#{user_id}</imei><imsi>#{user_id}</imsi><phoneNumber>0</phoneNumber><receiver>#{receiver}</receiver>"
    end
    response[:res_message][:result][0..26]
  end

  #Llamada al webservice "Create_withdraw" de Mobile Money
  def self.new_withdraw(teacher_id, teacher_pin, amount)
    client = Savon::Client.new(MOBILE_MONEY)
    response = client.request :wsdl, :create_withdraw do
      soap.body = "<sellerU>#{teacher_id}</sellerU><pin>#{teacher_pin}</pin><amount>#{amount}</amount><location>0,0</location><phoneNumber>0</phoneNumber><imei>#{teacher_id}</imei><imsi>#{teacher_id}</imsi>"
    end
    response[:res_message][:transaction_id]
  end

  #Llamada al webservice "Confirm_withdraw" de Mobile Money
  def self.confirm_withdraw(transaction, student_id, student_pin, amount)
    client = Savon::Client.new(MOBILE_MONEY)
    response = client.request :wsdl, :confirm_withdraw do
      soap.body = "<transactionId>#{transaction}</transactionId><userId>#{student_id}</userId><amount>#{amount}</amount><pin>#{student_pin}</pin><phoneNumber>0</phoneNumber><imei>#{student_id}</imei><imsi>#{student_id}</imsi>"
    end
    response[:res_message][:result][0..26]
  end

end
