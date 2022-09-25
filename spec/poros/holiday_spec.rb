require 'rails_helper'

RSpec.describe Holiday do
  it 'exists and has attributes' do
    VCR.use_cassette("holiday_data", :allow_playback_repeats => true) do
      holiday_data = HolidayService.get_data.first
      holiday = Holiday.new(holiday_data)
      expect(holiday).to be_instance_of(Holiday)
      expect(holiday.name).to be_instance_of(String)
      expect(holiday.date).to be_instance_of(String)
    end
  end
end