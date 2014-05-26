class ReviewsController < ApplicationController
  before_filter :require_user

  def create
    @video = Video.find(params[:video_id])
    review = @video.reviews.new(review_params.merge!(user: current_user))

    if review.save
      redirect_to @video
    else
      render 'videos/show'
    end
  end

  private
    def review_params
      params.require(:review).permit(:rating, :content)
    end
end