class QueueItemsController < ApplicationController
  before_filter :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    current_user.queue_items.create(video_id: params[:video_id])
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if current_user.queue_items.include?(queue_item)
    redirect_to my_queue_path
  end

  def batch_update
    flash.merge!(error: 'There was a problem saving changes') unless update_queue_items
    redirect_to my_queue_path
  end

  private
    def update_queue_items
      ActiveRecord::Base.transaction do
        begin
          current_user.update_queue_order(params[:queue_items])
        rescue
          raise ActiveRecord::Rollback
        end
      end
    end
end
