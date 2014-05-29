class FollowingController < ApplicationController
  before_filter :require_user

  def index
    @followings = current_user.following
  end

  def destroy
    following = Following.find(params[:id])
    following.destroy if current_user.following.include?(following)
    redirect_to people_path
  end
end
