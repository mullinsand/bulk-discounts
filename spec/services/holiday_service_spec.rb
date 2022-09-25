require 'rails_helper'


RSpec.describe GithubService do
  it 'gets all holiday data in an array of hashes' do
    VCR.use_cassette("holiday_data", :allow_playback_repeats => true) do
      expect(HolidayService.get_data).to be_instance_of(Array)
      expect(HolidayService.get_data.first).to be_instance_of(Hash)
      expect(HolidayService.get_data.first[:date]).to be_instance_of(String)
    end
  end
end