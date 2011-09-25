class SessionsController < ApplicationController
  def new
    redirect_to after_sign_in_path(current_user) if current_user
  end

  def create
    user = User.authenticate(params[:username], params[:password])
    ws_login = User.login_user(params[:username], params[:password]) if user
    if ws_login
		 if ws_login[:user_id].to_i >= 1
		   assign_session_credentials(user, ws_login) 
		   update_user_points(user)
		   redirect_to after_sign_in_path(user)
		 elsif ws_login[:user_id].to_i == -2
		   User.logout(ws_login[:user_id])
		   redirect_to log_in_path, :notice => "Ya te haz logueado en otro sistema"
		 else
		   User.logout(ws_login[:user_id])
		   redirect_to log_in_path, :notice => "Verifica tu nombre de usuario o contrasena"
		 end
    else 
		redirect_to log_in_path, :notice => "Usuario incorrecto"
    end
  end

  def destroy
    if User.logout(session[:user_id_ws])
      destroy_session_credentials
      redirect_to root_url
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
        menu_students_path
      elsif user.teacher?
        menu_teachers_path
      else
        users_path
      end
  end

  def update_user_points(user)
      user.update_attributes(:points => User.update_points(user.id))
  end

end
