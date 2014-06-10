class Admin::VideosController < AdminController

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      redirect_to new_admin_video_path, flash: {success: 'Successfully added video'}
    else
      flash[:error] = 'Could not create video'
      render :new
    end
  end

  private
    def video_params
      params.require(:video).permit(:title, :category_id, :description, :large_cover, :small_cover)
    end
end
