class User < ActiveRecord::Base
  
  has_one :operation, :foreign_key => "to_user_id", :class_name => "Operation"
  has_one :operation, :foreign_key => "from_user_id", :class_name => "Operation"

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
    client = Savon::Client.new(MOBILE_MONEY)
    user = User.find_by_username(username)

    response = client.request :wsdl, :login do
      soap.body = "<username>#{username}</username><password>#{password}</password><imei>#{user.id}</imei><imsi>#{user.id}</imsi>"
    end
    response[:res_message]
  end

  def self.logout(id)
    client = Savon::Client.new(MOBILE_MONEY)
    response = client.request :wsdl, :logout do
      soap.body = "<userId>#{id}</userId>"
    end
    response[:res_message][:user]
  end

  def student?
    self.type == 'Student'
  end

  def teacher?
    self.type == 'Teacher'
  end

end
