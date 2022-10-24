require 'rails_helper'

include Helpers


describe "Beer" do
    before :each do
        FactoryBot.create :brewery
        FactoryBot.create :user
        sign_in(username: "Pekka", password: "Foobar1")
        visit new_beer_path
    end

    it "adds new beer if name is not blank" do        
        fill_in('beer_name', with: 'Kalia')
        save_and_open_page

        expect{
        click_button('Create Beer')
        }.to change{Beer.count}.by(1)
    end

    it "do not add beer if name is blank" do
        click_button('Create Beer')

        expect(page).to have_content("Name can't be blank")
    end
end