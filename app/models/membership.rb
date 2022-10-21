class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :beer_club

  scope :member, -> { where confirmed: true }
  scope :applicant, -> { where confirmed: [nil, false] }
end
