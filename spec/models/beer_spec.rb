require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "is saved when name, style and brewery are set" do
    brewery = Brewery.create name: "panimo", year: 2000
    beer = Beer.create name: "olut", style: "lager", brewery: brewery

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without name" do
    brewery = Brewery.create name: "panimo", year: 2000
    beer = Beer.create style: "lager", brewery: brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without style" do
    brewery = Brewery.create name: "panimo", year: 2000
    beer = Beer.create name: "olut", brewery: brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
