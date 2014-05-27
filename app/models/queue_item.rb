class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  before_validation :set_position, if: :new_record?
  after_destroy :reorder_positions

  validates_presence_of :user, :video, :position

  validate :only_queued_item_per_video, on: :create

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def rating
    review = Review.where(user: user, video: video).first
    review.rating if review
  end

  def category_name
    category.name
  end

  private
    def only_queued_item_per_video
      return if user.nil? or video.nil?
      unless QueueItem.where(user: user, video: video).empty?
        errors.add(:base, 'Only one queue item allowed per video')
      end
    end

    def set_position
      return if self.user.nil?
      self.position = self.user.queue_items.count + 1
    end

    def reorder_positions
      user.queue_items.where('position > ?', position).each do |queue_item|
        queue_item.update(position: (queue_item.position - 1))
      end
    end
end