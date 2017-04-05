class AddResponseColumnToCalendar < ActiveRecord::Migration[5.0]
  def change
    add_column :calendars, :calendar_response, :text
  end
end
