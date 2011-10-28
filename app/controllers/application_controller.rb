class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :validate_current_session

  helper_method :current_user

  before_filter :notifications

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def validate_current_session
  	User.is_user_active?(session[:user_id]) if session[:user_id]
  end

  def notifications
  	dob = 
    @notifications ||= Student.where("strftime('%m-%d', dob) = ?", Time.new.strftime('%m-%d'))
  end

end
