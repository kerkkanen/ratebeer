require 'rails_helper'

describe "Beerlist page" do
  before :all do
    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(app, :browser => :chrome)
    end
  end

  before :all do
    Capybara.register_driver :chrome do |app|
      Capybara::Selenium::Driver.new app, browser: :chrome,
        options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu])
    end
  
    Capybara.javascript_driver = :chrome
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  before :each do
    @brewery1 = FactoryBot.create(:brewery, name: "Koff")
    @brewery2 = FactoryBot.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryBot.create(:brewery, name: "Ayinger")
    @style1 = Style.create name: "Lager"
    @style2 = Style.create name: "Rauchbier"
    @style3 = Style.create name: "Weizen"
    @beer1 = FactoryBot.create(:beer, name: "Nikolai", brewery: @brewery1, style:@style1)
    @beer2 = FactoryBot.create(:beer, name: "Fastenbier", brewery:@brewery2, style:@style2)
    @beer3 = FactoryBot.create(:beer, name: "Lechte Weisse", brewery:@brewery3, style:@style3)
  end

  it "shows a known beer", :js => true do
    visit beerlist_path
    find('table').find('tr:nth-child(1)')
    expect(page).to have_content "Nikolai"
  end

  it "shows beers ordered alphabetically by name", :js => true do
    visit beerlist_path
    first = find('#beertable').first('.tablerow')
    expect(first).to have_content "Fastenbier"
  end

  it "shows beers ordered alphabetically by style", :js => true do
    visit beerlist_path
    find_by_id("style").click
    first = find('#beertable').first('.tablerow')
    save_and_open_page
    expect(first).to have_content "Lager"
  end

  it "shows beers ordered alphabetically by brewery", :js => true do
    visit beerlist_path
    find_by_id("brewery").click
    first = find('#beertable').first('.tablerow')
    expect(first).to have_content "Ayinger"
  end
end
