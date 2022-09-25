require 'rails_helper'

RSpec.describe 'bulk discounts show' do
  VCR.insert_cassette("holiday_data", :allow_playback_repeats => true)
  describe "Show page has the discount and threshold for that bulk discount" do
    it 'shows discount and threshold for that bulk discount' do
      merch1 = create(:merchant)
      bulk_discount_1 = create(:bulk_discount, merchant: merch1)
      bulk_discount_2 = create(:bulk_discount, merchant: merch1)
      bulk_discount_3 = create(:bulk_discount, merchant: merch1)
      bulk_discount_4 = create(:bulk_discount, merchant: merch1)
      bulk_discount_5 = create(:bulk_discount)


      all_bulk_discounts = [bulk_discount_1, bulk_discount_2, bulk_discount_3, bulk_discount_4]
      visit merchant_bulk_discount_path(merch1.id, bulk_discount_1)

      within "#discount_#{bulk_discount_1.id}" do
        expect(page).to have_content("#{bulk_discount_1.discount}")
        expect(page).to have_content("#{bulk_discount_1.threshold}")
      end
      expect(page).to_not have_css("#discount_#{bulk_discount_5.id}")
      expect(page).to_not have_css("#discount_#{bulk_discount_2.id}")
    end
  end
  VCR.eject_cassette
end
