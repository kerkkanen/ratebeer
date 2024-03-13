class BreweriesApi

  def get_breweries
    url = "https://avoindata.prh.fi/bis/v1?totalResults=true&maxResults=500&businessLine=Oluen%20valmistus"

    response = HTTParty.get(url)

    breweries = []

    if response.code == 200
      data = response.parsed_response
      results = data["results"]

      results.each do |result|
        year = result["registrationDate"].split("-")
        brewery = {
          name: result["name"],
          year: year[0].to_i >= 1980 ? year[0] : "",
        }
        breweries << brewery
      end
    end

    breweries
  end
end
