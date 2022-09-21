require 'rails_helper'

RSpec.describe Merchant do
  describe 'Index page' do
    it 'should list all the merchants' do
      merch1 = Merchant.create!(name: "Tillies Store")
      merch2 = Merchant.create!(name: "Abby's Store")

      visit merchants_path

      expect(merch2.name).to appear_before(merch1.name)
      expect(merch1.name).to_not appear_before(merch2.name)
    end

  end
end