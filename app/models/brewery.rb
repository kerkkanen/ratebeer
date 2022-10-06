class Brewery < ApplicationRecord
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validate  :year_between_1040_and_now

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2007
    puts "changed year to #{year}"
  end

  def year_between_1040_and_now
    return if year != nil && year > 1040 && year <= Time.now.year

    errors.add(:year, "is invalid: must be between 1040 and current year")
  end
end
