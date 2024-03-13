class BreweriesApi
  def list_breweries
    url = "https://avoindata.prh.fi/bis/v1?totalResults=true&maxResults=500&businessLine=Oluen%20valmistus"

    response = HTTParty.get(url)

    breweries_list = []

    if response.code == 200
      data = response.parsed_response
      results = data["results"]
      breweries_list = create_listing(results)
    end

    breweries_list
  end

  private

  def create_listing(results)
    breweries = []

    results.each do |result|
      year = result["registrationDate"].split("-")
      brewery = {
        name: result["name"],
        year: year[0].to_i >= 1980 ? year[0] : "",
      }
      breweries << brewery
    end
    breweries
  end
end
