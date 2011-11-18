class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  helper_method :update_user_points

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
    @notifications ||= get_birthdays
  end

  #Metodo para sincronizar el balance de puntos del estudiante con la base de datos de los webservices
  def update_user_points(user)
      user.update_attributes(:points => User.update_points(user.id))
  end

   def get_birthdays
    students = []
    Student.all.each do |s|
      if s.dob.strftime('%m-%d') == Time.new.strftime('%m-%d')
        students.push(s)
      end
    end
    students
  end

  def is_bday?(student)
    student.dob.strftime('%m-%d') == Time.new.strftime('%m-%d')
  end

  def same_user?
    if params[:id].to_i == current_user.id
      redirect_to students_path, :notice => "No te puedes realizar donaciones a ti."
    end
  end
 
end
