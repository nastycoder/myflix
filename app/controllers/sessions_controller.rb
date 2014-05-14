class SessionsController < ApplicationController

  def new
    redirect_to home_path if current_user
  end

  def create
    user = User.find_by(email: params[:email])

    if user.try(:authenticate, params[:password])
      session[:user] = user.id
      redirect_to home_path
    else
      redirect_to sign_in_path, flash: {error: 'Invalid email or password.'}
    end
  end

  def destroy
    session[:user] = nil
    redirect_to root_path, notice: 'You are signed out'
  end
end
