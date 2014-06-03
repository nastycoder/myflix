class InvitesController < ApplicationController
  before_filter :require_user

  def new
    @invite = Invite.new
  end

  def create
    @invite = current_user.invites.new(invite_params)

    if @invite.save
      redirect_to new_invite_path, flash: { success: 'Invite has been sent' }
    else
      render :new
    end
  end

  private
    def invite_params
      params.require(:invite).permit(:name, :email, :message)
    end
end
