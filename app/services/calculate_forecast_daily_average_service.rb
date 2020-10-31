class CalculateForecastDailyAverageService
  def initialize(forecast)
    @forecast = forecast
  end

  def self.call(forecast)
    new(forecast).call
  end

  def call
    forecast_by_day = forecast.group_by { |f| f.dt.strftime('%d/%m') }

    forecast_by_day.keys.map do |day|
      day_forecasts = forecast_by_day[day]

      average = day_forecasts.sum { |f| f.main.temp } / day_forecasts.count

      { day: day, average: average.round }
    end
  end

  private

  attr_reader :forecast
end