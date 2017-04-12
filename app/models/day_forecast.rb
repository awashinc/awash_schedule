class DayForecast < ApplicationRecord

  def self.fetching(json)
    #  forecast_unixtime: nil, forecast_datetime: nil, condition: nil, icon_url: nil, all_response: nil
    days = json["forecastday"]
    days.each do |day|
      if DayForecast.where(forecast_unixtime: day["date"]["epoch"]).blank?
        self.create(forecast_unixtime: day["date"]["epoch"], forecast_datetime: DateTime.parse(day["date"]["pretty"]), condition: day["conditions"], icon_url: day["icon_url"], all_response: day)
      end
    end
  end
end
