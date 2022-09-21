require 'rails_helper'

RSpec.describe "Welcome page" do
  describe 'Welcome Page' do
    it 'should have links' do
      # merchants index page
      # admin index page
      # render layouts/application
      visit root_path
      expect(page).to have_link("Visit Admin Page")
      click_link "Visit Admin Page"
      expect(current_path).to eq admin_index_path

      visit root_path

      expect(page).to have_link("Visit Merchant Index")
      click_link "Visit Merchant Index"
      expect(current_path).to eq merchants_path
    end

  end
end