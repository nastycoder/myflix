class ApplicationController < ActionController::Base
  protect_from_forgery

  def require_user
    redirect_to sign_in_path, flash: {info: 'You must sign in first'} unless current_user
  end

  def current_user
    User.find(session[:user]) if session[:user]
  end

  helper_method :current_user
end
