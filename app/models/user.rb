class User < ApplicationRecord
  include RatingAverage
  
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  has_secure_password

  validates :username, uniqueness: true,
                       length: { minimum: 3,
                                 maximum: 30 }
  PASSWORD_REQUIREMENTS = /\A 
    (?=.{4})
    (?=.*\d)
    (?=.*[A-Z])
  /x
  validates :password, format: PASSWORD_REQUIREMENTS
  
end
