class CreateConfigs < ActiveRecord::Migration[5.0]
  def change
    create_table :configs do |t|
      t.datetime :half_forecast_point_date

      t.timestamps
    end
  end
end
