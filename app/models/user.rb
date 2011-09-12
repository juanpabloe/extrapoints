class User < ActiveRecord::Base
  
  attr_accessor :password
  attr_accessible :email, :username, :password, :password_confirmation

  before_save :encrypt_password

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  def self.authenticate(email, password)
    user = find_by_email(email)
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

  def login_user(username, password, ip_address)
    client = Savon::Client.new("http://10.16.194.209:8080/mobileMoney/webServiceBackup2.php?wsdl")

    response = client.request :wsdl, :login do
      soap.body =
        "<username>#{username}</username>
        <password>#{password}</password>
        <imei>#{ip_address}</imei>"
    end

  end

end
