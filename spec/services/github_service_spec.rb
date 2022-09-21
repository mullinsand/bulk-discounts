require 'rails_helper'


RSpec.describe GithubService do
  it 'does stuff' do
    VCR.use_cassette "repo_name_data" do
      expect(GithubService.get_repo_name_data).to eq("little-esty-shop")
    end

    VCR.use_cassette "teammate_data" do
      expect(GithubService.get_teammate_data).to eq("little-esty-shop")
    end

  end
end