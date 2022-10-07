class WeatherApi
  def self.current_weather(city)
    url = "http://api.weatherstack.com/current?access_key=#{key}&query=#{city}"
    puts url
    response = HTTParty.get url.to_s

    response["current"]
  end

  def self.key
    return nil if Rails.env.test? # testatessa ei apia tarvita, palautetaan nil
    raise 'WEATHER_APIKEY env variable not defined' if ENV['WEATHER_APIKEY'].nil?

    ENV.fetch('WEATHER_APIKEY')
  end
end
