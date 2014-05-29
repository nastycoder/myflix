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
end
