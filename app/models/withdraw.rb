class Withdraw < Operation

	validates_presence_of :amount
	validates_numericality_of :amount, :greater_than => 0
	validates_presence_of :description

  def self.create_wd(teacher_id, teacher_pin, amount)
    client = Savon::Client.new(MOBILE_MONEY)
    response = client.request :wsdl, :create_withdraw do
      soap.body = "<sellerU>#{teacher_id}</sellerU><pin>#{teacher_pin}</pin><amount>#{amount}</amount><location>0,0</location><phoneNumber>0</phoneNumber><imei>#{teacher_id}</imei><imsi>#{teacher_id}</imsi>"
    end
    response[:res_message][:transaction_id]
  end

  def self.confirm_wd(transaction, student_id, student_pin, amount)
    client = Savon::Client.new(MOBILE_MONEY)
    response = client.request :wsdl, :confirm_withdraw do
      soap.body = "<transactionId>#{transaction}</transactionId><userId>#{student_id}</userId><amount>#{amount}</amount><pin>#{student_pin}</pin><phoneNumber>0</phoneNumber><imei>#{student_id}</imei><imsi>#{student_id}</imsi>"
    end
    response[:res_message][:result][0..26]
  end

end
