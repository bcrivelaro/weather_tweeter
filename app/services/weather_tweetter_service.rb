class WeatherTweetterService
  def initialize(location_params)
    @location_params = location_params
  end

  def self.call(location_params)
    new(location_params).call
  end

  def call
    weather = open_weather_client.weather.find_by(location_params)
    forecast = open_weather_client.forecast.find_by(location_params)

    message = build_tweet(weather, forecast)

    twitter_client.update(message)

    message
  end

  private

  attr_reader :location_params

  def open_weather_client
    options = { lang: 'pt_br', units: 'metric' }
    @open_weather_client ||= OpenWeather.client(ENV['OPEN_WEATHER_API_KEY'], options)
  end

  def build_tweet(weather, forecast)
    temperature = weather.main.temp.round
    description = weather.weather[0].description
    city = weather.name
    today = Date.today.strftime('%d/%m')
    forecast_description = build_forecast_description(forecast, today)

    "#{temperature}°C e #{description} em #{city} em #{today}. " +
      "Média para os próximos dias: #{forecast_description}."
  end

  def build_forecast_description(forecast, today)
    forecast_average = CalculateForecastDailyAverageService.call(forecast)
    next_days_forecast = forecast_average.select { |fa| fa[:day] != today }

    forecast_description = next_days_forecast.map do |forecast_average|
      "#{forecast_average[:average]}°C em #{forecast_average[:day]}"
    end.to_sentence(words_connector: ', ', last_word_connector: ' e ')
  end

  def twitter_client
    @twitter_client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
    end
  end
end