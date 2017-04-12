class AddIsExtendColumnToCalendar < ActiveRecord::Migration[5.0]
  def change
    add_column :calendars, :is_extend, :integer, default: 0
  end
end
