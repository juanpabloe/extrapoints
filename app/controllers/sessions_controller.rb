class SessionsController < ApplicationController

  def new
    redirect_to users_path if current_user
  end

  def create
    user = User.authenticate(params[:username], params[:password])
    ws_login = User.login_user(params[:username], params[:password])
    if user and ws_login[:user_id].to_i >= 1
      assign_session_credientials(user, ws_login) 
      if user.student?
        redirect_to students_path
      elsif user.teacher?
        redirect_to teachers_path
      else
        redirect_to users_path
      end
    else
      User.logout(ws_login[:user_id])
      render "new"
    end
  end

  def destroy
    if User.logout(session[:user_id_ws])
      destroy_session_credientials
      redirect_to root_url, :notice => "Logged Out!"
    else
      flash.now.alert = "Can't logout"
    end
  end

  def assign_session_credientials(user, ws_login)
      session[:user_id] = user.id
      session[:user_id_ws] = ws_login[:user_id]
  end

  def destroy_session_credentials
      session[:user_id] = nil
      session[:user_id_ws] = nil
  end

end
