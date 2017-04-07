class Calendar < ApplicationRecord

  validates :start_date, :end_date, :address, :car_number, presence: true

  after_create do |cal|
  end


end
