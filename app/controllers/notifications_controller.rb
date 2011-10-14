class NotificationsController < ApplicationController

  def index 
    #Temporal para implementar con mas notificaciones
    notifications = current_user.notifications if current_user
    @bday_students = Student.where("strftime('%m-%d', dob) = ?", Time.new.strftime('%m-%d'))
  end

end
