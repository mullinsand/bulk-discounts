require 'rails_helper'


RSpec.describe GithubService do
  it 'does stuff' do
    expect(GithubService.get_repo_name_data).to eq('bob')
  end

end