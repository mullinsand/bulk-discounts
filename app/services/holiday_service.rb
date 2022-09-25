class HolidayService
  def self.get_data(country = "US")
    uri = "https://date.nager.at/api/v3/NextPublicHolidays/#{country}"
    require 'pry'; binding.pry
    response = HTTParty.get(uri)
    body = response.body
    parsed = JSON.parse(body, symbolize_names: true)
  end
end