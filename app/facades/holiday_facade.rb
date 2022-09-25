class HolidayFacade

  def self.get_holidays
    parsed = HolidayService.get_data
    holidays = parsed[0..2].map do |holiday_data|
      Holiday.new(holiday_data)
    end
  end
end