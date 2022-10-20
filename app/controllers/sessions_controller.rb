class SessionsController < ApplicationController
  def index
  end

  def new
  end

  def create
    session[:search_city] = nil
    user = User.find_by username: params[:username]
    # tarkastetaan että käyttäjä olemassa, ja että salasana on oikea
    if user&.authenticate(params[:password])
      if user.active
        session[:user_id] = user.id
        if user.admin
          session[:admin] = true
        end
        redirect_to user_path(user), notice: "Welcome back!"
      else
        redirect_to signin_path, notice: "Your account is closed, please contact with admin"
      end
    else
      redirect_to signin_path, notice: "Username and/or password mismatch"
    end
  end

  def destroy
    session[:user_id] = nil
    session[:admin] = nil
    redirect_to signin_path
  end
end
