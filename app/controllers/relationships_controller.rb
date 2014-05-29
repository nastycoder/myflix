class RelationshipsController < ApplicationController
  before_filter :require_user

  def index
    @relationships = current_user.following
  end

  def destroy
    relationship = Relationship.find(params[:id])
    relationship.destroy if current_user.following.include?(relationship)
    redirect_to people_path
  end

  def create
    followed = User.find(params[:followed_id])
    current_user.following.create(followed: followed) if current_user.can_follow?(followed)
    redirect_to people_path
  end
end
