class VideoDecorator < Draper::Decorator
  delegate_all
  def rating_text
    object.reviews.any? ? "#{object.average_rating}/5.0" : 'N/A'
  end
end
