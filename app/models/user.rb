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

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    styles = (ratings.map{ |rating| rating.beer.style })
    keys = styles.uniq
    scores = ratings.map{ |r| [r.beer.style, r.score] }
    favorite_beers(styles, scores, keys)
  end

  def favorite_beers(styles, scores, keys)
    beers = {}
    keys.each{ |s| beers[s] = 0 }
    scores.each{ |score| beers[score[0]] += score[1] }
    beers.each do |style, score|
      beers[style] = score / styles.count(style)
    end
    beers.invert.max&.last
  end

  def favorite_brewery
    return nil if ratings.empty?

    breweries = (ratings.map{ |rating| rating.beer.brewery })
    keys = breweries.uniq
    scores = ratings.map{ |r| [r.beer.brewery, r.score] }
    favorite_breweries(breweries, scores, keys)
  end

  def favorite_breweries(breweries, scores, keys)
    brews = {}
    keys.each{ |s| brews[s] = 0 }
    scores.each{ |score| brews[score[0]] += score[1] }
    brews.each do |brewery, score|
      brews[brewery] = score / breweries.count(brewery)
    end
    brews.invert.max&.last&.name
  end

  def self.active(n)
    User.all.sort_by{ |u| u.ratings.count }.reverse.first(n)
  end
end
