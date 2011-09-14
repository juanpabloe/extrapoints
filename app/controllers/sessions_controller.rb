class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:username], params[:password])
    ws_login = User.login_user(params[:username], params[:password])
    if ws_login[:logintype].to_i >= 1
      session[:user_id] = user.id
      session[:user_id_ws] = ws_login[:user_id]
      redirect_to root_url, :notice => "Logged In!"
    else
      User.logout(ws_login[:user_id])
      flash.now.alert = "Invalid username or password"
      render "new"
    end
  end

  def destroy
    if User.logout(session[:user_id_ws])
      session[:user_id] = nil
      session[:user_id_ws] = nil
      redirect_to root_url, :notice => "Logged Out!"
    else
      flash.now.alert = "Can't logout"
    end
  end

end
