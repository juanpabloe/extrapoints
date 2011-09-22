class Donation < Operation


  def self.begin_transfer(user_id, amount, pin, receiver)
    client = Savon::Client.new(MOBILE_MONEY)
    response = client.request :wsdl, :begin_transfer do
      soap.body="<userId>#{user_id}</userId><amount>#{amount}</amount><pin>#{pin}</pin><location>0,0</location><imei>#{user_id}</imei><imsi>#{user_id}</imsi><phoneNumber>0</phoneNumber><receiver>#{receiver}</receiver>"
    end
    response[:res_message][:result][0..26]
  end

end
