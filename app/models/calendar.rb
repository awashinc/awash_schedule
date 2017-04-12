class Calendar < ApplicationRecord

  validates :start_date, :end_date, :address, :car_number, presence: true

  after_create do |cal|
  end

  
  PERIOD_STR=[
    "충전",
    "주1회",
    "주2회"
  ]


  WEEKDAY_STR=[
    "월요일",
    "화요일",
    "수요일",
    "목요일",
    "금요일",
    "토요일",
    "일요일"
  ]

  def wash_recursive_str
    "#{PERIOD_STR[self.per_wash]} / #{WEEKDAY_STR[self.day_sel]}"
  end

  def dup_calendar
     calendar = self.dup
     calendar.calendar_id = nil
     calendar.start_date = calendar.end_date + 1.week
     calendar.end_date = calendar.start_date + 1.month
     calendar.calendar_response =nil
     calendar
  end

  def update_extend
    self.update_attributes(is_extend: 1)
  end

end
