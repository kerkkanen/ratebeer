class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery, touch: true
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  validates :name, presence: true

  def to_s
    "#{name} (#{brewery.name})"
  end

  def self.top(n)
    Beer.all.sort_by(&:average_rating).reverse.first(n)
  end
end
