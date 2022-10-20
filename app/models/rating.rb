class Rating < ApplicationRecord
  belongs_to :beer
  belongs_to :user
  validates :score, numericality: { greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 50,
                                    only_integer: true }

  def to_s
    "#{beer.name}, scores: #{score}"
  end

  def self.latest(n)
    sorted_by_time_in_desc_order = Rating.all.sort.last(n)
  end
end
