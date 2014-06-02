class ForgotPasswordController < ApplicationController

  def create
    user = User.where(email: params[:email]).first
    if user
      user.forgot_password
      redirect_to forgot_password_confirmation_path
    else
      flash[:error] = params[:email].blank? ? 'Email cannot be blank' : 'No account found'
      redirect_to forgot_password_path
    end
  end
end
