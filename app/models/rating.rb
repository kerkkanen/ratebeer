module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return 0 if ratings.empty?

    ((ratings.reduce(0.0) { |sum, rating| sum + rating.score }) / ratings.count).round(1)
  end
end
class Rating < ApplicationRecord
  belongs_to :beer, touch: true
  belongs_to :user
  validates :score, numericality: { greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 50,
                                    only_integer: true }

  def to_s
    "#{beer.name}, scores: #{score}"
  end

  def self.latest(n)
    Rating.all.sort.last(n)
  end
end
