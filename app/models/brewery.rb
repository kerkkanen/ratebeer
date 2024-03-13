class Brewery < ApplicationRecord
  include RatingAverage

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1040,
                                   only_integer: true }
  validate :year_not_greater_than_this_year

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }

  def self.top(amount)
    sorted_by_rating_in_desc_order = Brewery.all.sort_by { |b| -(b.average_rating || 0) }
    sorted_by_rating_in_desc_order[0, amount]
  end

  def year_not_greater_than_this_year
    return if year.nil?

    year > Time.now.year ? errors.add(:year, "can't be greater than current year") : ""
  end

  after_create_commit do
    target_id = active ? "active_brewery_rows" : "retired_brewery_rows"
    count = active ? Brewery.active.count : Brewery.retired.count
    status = active ? "active" : "retired"

    broadcast_append_to "breweries_index", partial: "breweries/brewery_row", target: target_id
    broadcast_replace_to "breweries_index", partial: "breweries/list_headers", target: "#{status}_count", locals: { status:, count: }
  end

  after_destroy_commit do
    status = active ? "active" : "retired"
    count = active ? Brewery.active.count : Brewery.retired.count

    broadcast_remove_to "breweries_index", target: "brewery_#{id}"
    broadcast_replace_to "breweries_index", partial: "breweries/list_headers", target: "#{status}_count", locals: { status:, count: }
  end
end
