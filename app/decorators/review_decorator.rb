class ReviewDecorator < Draper::Decorator
  delegate_all
  def rating_text
    "#{object.rating} / 5"
  end
end
