class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates_presence_of :rating, :user, :video, :content
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }

  def decorator
    ReviewDecorator.decorate(self)
  end
end
