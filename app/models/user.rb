class User < ActiveRecord::Base
  
  attr_accessor :password

  #Username tiene que ser la matricula
  attr_accessible :email, :username, :password, :password_confirmation,
                  :first_name, :last_name, :dob, :points

  before_save :encrypt_password

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email, :username
  validates_uniqueness_of :email, :username

  def self.authenticate(username, password)
    user = find_by_username(username)
    if user && user.password_hash = BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def self.login_user(username, password)
    client = Savon::Client.new("http://10.16.194.209:8080/mobileMoney/webServiceBackup2punto0.php?wsdl")

    response = client.request :wsdl, :login do
      soap.body =
        "<username>#{username}</username>
        <password>#{password}</password>
        <imei>nil</imei>"
    end
    response[:res_message]
  end

  def self.logout(id)
    client = Savon::Client.new("http://10.16.194.209:8080/mobileMoney/webServiceBackup2punto0.php?wsdl")

    response = client.request :wsdl, :logout do
      soap.body =
        "<userId>#{id}</userId>"
    end
    response[:res_message][:user]
  end

end
