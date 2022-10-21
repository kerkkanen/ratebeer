class BeerClub < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  validates :name, :city, presence: true
  validate  :year_between_1040_and_now

  def year_between_1040_and_now
    return if !founded.nil? && founded > 1040 && founded <= Time.now.year

    errors.add(:founded, "is invalid: must be between 1040 and current year")
  end
end
