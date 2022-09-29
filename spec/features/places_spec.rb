require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end
  it "if API returns multiple places, they all are shown" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
        [ Place.new( name: "Oljenkorsi", id: 1 ),
          Place.new( name: "R-kioskin kaljahylly", id: 2 ) ],
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"
  
    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "R-kioskin kaljahylly"
  end

  it "shows messages if no places are found" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return([])

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"
  
    expect(page).to have_content "No locations in kumpula"
  end
end