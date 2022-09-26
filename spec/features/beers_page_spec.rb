require 'rails_helper'


describe "Beer" do
    before :each do
        FactoryBot.create :brewery
        visit new_beer_path
    end

    it "adds new beer if name is not blank" do        
        fill_in('beer_name', with: 'Kalia')

        expect{
        click_button('Create Beer')
        }.to change{Beer.count}.by(1)
    end

    it "do not add beer if name is blank" do
        click_button('Create Beer')

        expect(page).to have_content("Name can't be blank")
    end
end