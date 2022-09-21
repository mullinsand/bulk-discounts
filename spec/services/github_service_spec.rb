require 'rails_helper'


RSpec.describe GithubService do
  it 'does stuff' do
    VCR.use_cassette "repo_name_data" do
      expect(GithubService.get_repo_name_data).to eq("little-esty-shop")
    end
  end

  describe '#teammate_data' do

    it 'displays the correct amount of data in the correct format' do
      VCR.use_cassette "teammate_data" do
        expect(GithubService.get_teammate_data).to be_a(Array)
        # expect(GithubService.get_teammate_data.count).to eq(4)
      end
    end

    it 'gets teammate usernames' do
      VCR.use_cassette "teammate_data" do
        expect(GithubService.get_teammate_data.first.username).to eq("cballrun")
      end
    end

    it 'gets teammate commits' do
      VCR.use_cassette "teammate_data" do
        expect(GithubService.get_teammate_data.first.commits).to eq(73)
      end
    end
    
  end
end