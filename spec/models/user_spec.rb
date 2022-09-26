require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "A"

    expect(user.username).to eq("A")
  end

  it "is not saved without a password" do
    user = User.create username: "C"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with too short password" do
    user = User.create username: "D", password: "Mo1", password_confirmation: "Mo1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with password without capital letter" do
    user = User.create username: "E", password: "moimoi1", password_confirmation: "moimoi1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end
  
    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
    
      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beer_with_rating({ user: user }, 10 )
      create_beer_with_rating({ user: user }, 7 )
      best = create_beer_with_rating({ user: user }, 25 )
    
      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style beer" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
    
      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the one with highest rating if several rated" do
      create_beer_with_rating({ user: user }, 10, create_beer_with_style("lager") )
      create_beer_with_rating({ user: user }, 7, create_beer_with_style("IPA")  )
      best = create_beer_with_rating({ user: user }, 25, create_beer_with_style("weizen")  )
    
      expect(user.favorite_style).to eq(best.style)
    end  
  end

  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_brewery).to eq(beer.brewery.name)  
    end

    it "is the one with highest rating if several rated" do
      create_beer_with_rating({ user: user }, 10, create_beer_with_brewery("Olvi") )
      create_beer_with_rating({ user: user }, 7, create_beer_with_brewery("Koff")  )
      best = create_beer_with_rating({ user: user }, 25, create_beer_with_brewery("Brewdog")  )
    
      expect(user.favorite_brewery).to eq(best.brewery.name)
    end  
  end

def create_beer_with_style(style)
  beer = FactoryBot.create(:beer, style: style)
end

def create_beer_with_brewery(name)
  brewery = FactoryBot.create(:brewery, name: name)
  beer = FactoryBot.create(:beer, brewery_id: brewery.id)
end
end