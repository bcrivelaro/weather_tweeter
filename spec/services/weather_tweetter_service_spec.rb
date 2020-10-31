RSpec.describe WeatherTweetterService do
  describe '.call' do
    it 'does fetch data from OpenWeather API and post a tweet' do
      location_params = { q: 'New York' }

      open_weather_client = double(OpenWeather::Client)
      expect(OpenWeather).to receive(:client) { open_weather_client }
      weather = double(OpenWeather::Entities::Weather, name: 'New York')
      expect(weather).to receive_message_chain(:main, :temp) { 20.15 }
      expect(weather).to receive(:weather) { [double(:weather, description: 'Nublado')] }
      expect(open_weather_client).to(
        receive_message_chain(:weather, :find_by)
          .with(location_params)
          .and_return(weather)
      )
      forecast = [
        double(OpenWeather::Entities::Forecast),
        double(OpenWeather::Entities::Forecast),
        double(OpenWeather::Entities::Forecast)
      ]
      expect(open_weather_client).to(
        receive_message_chain(:forecast, :find_by)
          .with(location_params)
          .and_return(forecast)
      )
      forecast_average = [
        { day: 1.day.from_now.strftime('%d/%m'), average: 19 },
        { day: 2.days.from_now.strftime('%d/%m'), average: 16 },
        { day: 3.days.from_now.strftime('%d/%m'), average: 22 },
        { day: 4.days.from_now.strftime('%d/%m'), average: 25 },
        { day: 5.days.from_now.strftime('%d/%m'), average: 18 }
      ]
      expect(CalculateForecastDailyAverageService).to(
        receive(:call)
          .with(forecast)
          .and_return(forecast_average)
      )
      twitter_client = double(Twitter::REST::Client)
      expect(Twitter::REST::Client).to receive(:new) { twitter_client }
      expected_message = "20°C e Nublado em New York em #{Date.today.strftime('%d/%m')}. " \
                         "Média para os próximos dias: " \
                         "19°C em #{1.day.from_now.strftime('%d/%m')}, " \
                         "16°C em #{2.days.from_now.strftime('%d/%m')}, " \
                         "22°C em #{3.days.from_now.strftime('%d/%m')}, " \
                         "25°C em #{4.days.from_now.strftime('%d/%m')} e " \
                         "18°C em #{5.days.from_now.strftime('%d/%m')}."
      expect(twitter_client).to receive(:update).with(expected_message)

      WeatherTweetterService.call(location_params)
    end
  end
end