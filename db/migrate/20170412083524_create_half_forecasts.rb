class CreateHalfForecasts < ActiveRecord::Migration[5.0]
  def change
    create_table :half_forecasts do |t|
      t.datetime :point_date
      t.string :weekday
      t.string :icon_url
      t.text :forecast_text
      t.text :all_response

      t.timestamps
    end
  end
end
