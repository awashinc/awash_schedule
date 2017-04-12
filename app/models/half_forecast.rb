class HalfForecast < ApplicationRecord

  def self.fetching(json)
    #  point_date: nil, weekday: nil, forecast_text: nil, all_response: nil,
    days = json["forecastday"]
    date = json["date"]
    days.each do |day|
      if HalfForecast.where(point_date: DateTime.parse(date), weekday: day["title"]).blank?
        self.create(point_date: date, weekday: day["title"], forecast_text: day["fcttext_metric"], icon_url: day["icon_url"], all_response: day)
      end
    end
  end

end
