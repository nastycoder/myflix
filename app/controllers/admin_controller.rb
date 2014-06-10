class AdminController < ApplicationController
  before_filter :require_user
  before_filter :ensure_admin
  def ensure_admin
    redirect_to home_path, flash: {error: 'Your not suppose to go there'} unless current_user.admin?
  end
end
