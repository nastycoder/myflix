module VideosHelper
  def rating_options
    (1..5).map{ |number| [pluralize(number, 'Star'), number] }.reverse
  end
end
