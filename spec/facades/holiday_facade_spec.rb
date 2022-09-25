require 'rails_helper'

RSpec.describe HolidayFacade do
  describe "get_holidays" do
    it 'returns an array 3 elements long' do
      VCR.use_cassette("holiday_data", :allow_playback_repeats => true) do
          expect(HolidayFacade.get_holidays).to be_instance_of(Array)
          expect(HolidayFacade.get_holidays.size).to eq(3)
      end
    end

    it 'elements in array are Holiday class' do
      VCR.use_cassette("holiday_data", :allow_playback_repeats => true) do
          expect(HolidayFacade.get_holidays[0]).to be_instance_of(Holiday)
      end
    end
  end
end