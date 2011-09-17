class SessionsController < ApplicationController

  def new
    redirect_to after_sign_in_path(current_user) if current_user
  end

  def create
    user = User.authenticate(params[:username], params[:password])
    ws_login = User.login_user(params[:username], params[:password])
    if user and ws_login[:user_id].to_i >= 1
      assign_session_credentials(user, ws_login) 
      redirect_to after_sign_in_path(user)
    else
      User.logout(ws_login[:user_id])
      render "new"
    end
  end

  def destroy
    if User.logout(session[:user_id_ws])
      destroy_session_credentials
      redirect_to root_url, :notice => "Logged Out!"
    else
      flash.now.alert = "Can't logout"
    end
  end

  def assign_session_credentials(user, ws_login)
      session[:user_id] = user.id
      session[:user_id_ws] = ws_login[:user_id]
  end

  def destroy_session_credentials
      session[:user_id] = nil
      session[:user_id_ws] = nil
  end

  def after_sign_in_path(user)
      if user.student?
        students_path
      elsif user.teacher?
        teachers_path
      else
        users_path
      end
  end

end
