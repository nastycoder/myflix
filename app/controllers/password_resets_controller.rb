class PasswordResetsController < ApplicationController
  def show
    @user = User.where(token: params[:id]).first
    redirect_to expired_token_path unless @user
  end

  def create
    user = User.where(token: params[:token]).first
    if user
      user.reset_password(params[:password])
      redirect_to sign_in_path, flash: {success: 'Password reset successful' }
    else
      redirect_to expired_token_path
    end
  end
end
