class UsersController < ApplicationController
  before_filter :require_user, only: :show

  def new
    @user = User.new
  end

  def new_from_invite
    invite = Invite.where(token: params[:invite_token]).first
    if invite
      @user = User.new(email: invite.email)
      @invite_token = invite.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  def create
    @user = User.new(user_params)
    result = UserSignup.new(@user).sign_up(params[:stripeToken], params[:invite_token])
    if result.successful?
      redirect_to sign_in_path, flash: {success: 'Thanks for joining please sign in'}
    else
      flash[:error] = result.error_message
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private
    def user_params
      params.require(:user).permit(:full_name, :email, :password)
    end
end
