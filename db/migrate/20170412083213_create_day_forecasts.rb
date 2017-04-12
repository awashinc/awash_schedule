class CreateDayForecasts < ActiveRecord::Migration[5.0]
  def change
    create_table :day_forecasts do |t|
      t.integer :forecast_unixtime
      t.datetime :forecast_datetime
      t.string :condition
      t.string :icon_url
      t.text :all_response

      t.timestamps
    end
  end
end
