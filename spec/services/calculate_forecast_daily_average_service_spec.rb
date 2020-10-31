RSpec.describe CalculateForecastDailyAverageService do
  describe '.call' do
    it 'does return forecast temperature average grouped by day' do
      forecast = [
        double(:forecast_item, dt: 1.day.from_now.to_time,
                               main: double(:main, temp: 18)),
        double(:forecast_item, dt: 1.day.from_now.to_time,
                               main: double(:main, temp: 19)),
        double(:forecast_item, dt: 1.day.from_now.to_time,
                               main: double(:main, temp: 20)),
        double(:forecast_item, dt: 2.days.from_now.to_time,
                               main: double(:main, temp: 15)),
        double(:forecast_item, dt: 2.days.from_now.to_time,
                               main: double(:main, temp: 16)),
        double(:forecast_item, dt: 2.days.from_now.to_time,
                               main: double(:main, temp: 17)),
        double(:forecast_item, dt: 3.days.from_now.to_time,
                               main: double(:main, temp: 21)),
        double(:forecast_item, dt: 3.days.from_now.to_time,
                               main: double(:main, temp: 22)),
        double(:forecast_item, dt: 3.days.from_now.to_time,
                               main: double(:main, temp: 23)),
        double(:forecast_item, dt: 4.days.from_now.to_time,
                               main: double(:main, temp: 24)),
        double(:forecast_item, dt: 4.days.from_now.to_time,
                               main: double(:main, temp: 25)),
        double(:forecast_item, dt: 4.days.from_now.to_time,
                               main: double(:main, temp: 26)),
        double(:forecast_item, dt: 5.days.from_now.to_time,
                               main: double(:main, temp: 17)),
        double(:forecast_item, dt: 5.days.from_now.to_time,
                               main: double(:main, temp: 18)),
        double(:forecast_item, dt: 5.days.from_now.to_time,
                               main: double(:main, temp: 19))
      ]

      average = CalculateForecastDailyAverageService.call(forecast)

      expected_average = [
        { day: 1.day.from_now.strftime('%d/%m'), average: 19 },
        { day: 2.days.from_now.strftime('%d/%m'), average: 16 },
        { day: 3.days.from_now.strftime('%d/%m'), average: 22 },
        { day: 4.days.from_now.strftime('%d/%m'), average: 25 },
        { day: 5.days.from_now.strftime('%d/%m'), average: 18 }
      ]
      expect(average).to eq(expected_average)
    end
  end
end