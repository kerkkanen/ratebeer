class Style < ApplicationRecord
  
  def to_s
    name.to_s
  end

  def self.top(n)
    ratings = Rating.all.map{|r| [r.beer.style_id, r.score]}
    ids = ratings.map{|r| r[0]}
    styles = Style.all.map{|s| s.id}
    results = {}
    styles.each do |s|
      results[s] = 0
    end
    ratings.map{|r| results[r[0]] += r[1]}
    results.each do |key, value|
      if ids.count(key) > 0
        results[key] = value/(ids.count(key))
      end
    end
    (results.sort_by{|k, v| v}.last(n).map{|r| [Style.where(id: r[0]), r[1]]}).reverse
  end
end
