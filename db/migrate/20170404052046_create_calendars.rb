class CreateCalendars < ActiveRecord::Migration[5.0]
  def change
    create_table :calendars do |t|
      t.string :calendar_id
      t.string :name
      t.integer :per_wash
      t.integer :wash_type
      t.date :start_date
      t.date :end_date
      t.integer :day_sel
      t.time :time_sel
      t.string :phone
      t.string :address
      t.string :car_number
      t.text :memo

      t.timestamps
    end
  end
end
