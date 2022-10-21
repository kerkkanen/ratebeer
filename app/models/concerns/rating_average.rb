module RatingAverage
  extend ActiveSupport::Concern

  def average_rating(ratings)
    # tehdään laskelmat muistiin haettujen olueen liittyvien ratings-olioiden avulla
    rating_count = ratings.size

    return 0 if rating_count == 0
    ratings.map{ |r| r.score }.sum / rating_count
  end
end