require 'rails_helper'

include Helpers

describe "Rating" do
    let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
    let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery:brewery }
    let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
    let!(:user) { FactoryBot.create :user }

    before :each do
      sign_in(username: "Pekka", password: "Foobar1")
    end

    it "when given, is registered to the beer and user who is signed in" do
      visit new_rating_path
      select('iso 3', from: 'rating[beer_id]')
      fill_in('rating[score]', with: '15')

      expect{
      click_button "Create Rating"
      }.to change{Rating.count}.from(0).to(1)

      expect(user.ratings.count).to eq(1)
      expect(beer1.ratings.count).to eq(1)
      expect(beer1.average_rating).to eq(15.0)
    end

    it "shows the number of ratings correctly" do
      create_beer_with_rating({ user: user }, 10 )
      create_beer_with_rating({ user: user }, 14 )
      create_beer_with_rating({ user: user }, 16 )
      visit ratings_path

      expect(page).to have_content("Number of ratings: #{Rating.count()}")
    end

    it "shows in users own page" do
        create_beer_with_rating({ user: user }, 10 )
        create_beer_with_rating({ user: user }, 14 )
        create_beer_with_rating({ user: FactoryBot.create(:user, username: "Maussi") }, 16 )
        visit user_path(user)
  
        expect(page).to have_content("Has made #{Rating.where(user_id: user.id).count()}")
    end

    it "is deleted from database when user deletes it" do
        rating = FactoryBot.create(:rating, user: user)
        FactoryBot.create(:rating, score: 12, user: user)
        visit user_path(user)
        find_link(href: "/ratings/#{rating.id}").click

        expect(Rating.where(id: rating.id)[0]).to eq(nil)        
    end

    it "creates user's favorite brewery and beer style correct in own page" do
      brewery_x = FactoryBot.create(:brewery, name: "Olvi") 
      beer_x = FactoryBot.create(:beer, style: "porter", brewery_id: 2)
      rating1 = FactoryBot.create(:rating, score: 20, beer: beer1, user: user)
      rating2 = FactoryBot.create(:rating, score: 30, beer: beer_x, user: user)
      visit user_path(user)

      expect(page).to have_content("#{user.favorite_style}")
      expect(page).to have_content("#{user.favorite_brewery}")
    end    
end
