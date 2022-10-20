module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return 0 if ratings.empty?

    ((ratings.reduce(0.0) { |sum, rating| sum + rating.score }) / ratings.count)
  end
end
