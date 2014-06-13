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

    if @user.save
      handle_invite
      handle_charge
      redirect_to sign_in_path
    else
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

    def handle_invite
      invite = Invite.where(token: params[:invite_token]).first
      if invite
        invite.accepted_by(@user)
      end
    end

    def handle_charge
      StripeWrapper::Charge.create(
        amount:        999,
        card:         params[:stripeToken],
        description:  "New Member charge for #{@user.email}"
      )
    end
end
