require 'rails_helper'

RSpec.describe 'bulk discounts Index' do
  describe "A list of all bulk discount names" do
    it 'shows the names of each bulk discount' do
      merch1 = create(:merchant)
      bulk_discount_1 = create(:bulk_discount, merchant: merch1)
      bulk_discount_2 = create(:bulk_discount, merchant: merch1)
      bulk_discount_3 = create(:bulk_discount, merchant: merch1)
      bulk_discount_4 = create(:bulk_discount, merchant: merch1)
      bulk_discount_5 = create(:bulk_discount)


      all_bulk_discounts = [bulk_discount_1, bulk_discount_2, bulk_discount_3, bulk_discount_4]
      visit merchant_bulk_discounts_path(merch1.id)

      within '#discounts' do
        all_bulk_discounts.each do |bulk_discount|
          within "#discount_#{bulk_discount.id}" do
            expect(page).to have_content("#{bulk_discount.discount}")
            expect(page).to have_content("#{bulk_discount.threshold}")
          end
        end
      end
    end

    xit 'has each merchant name is a link to the admin merchant show page' do
      merch1 = Merchant.create!(name: Faker::Name.name)
      merch2 = Merchant.create!(name: Faker::Name.name)
      merch3 = Merchant.create!(name: Faker::Name.name)
      merch4 = Merchant.create!(name: Faker::Name.name)
      merch5 = Merchant.create!(name: Faker::Name.name)

      all_merchants = [merch1, merch2, merch3, merch4, merch5]
      visit admin_merchants_path

      within '#merchants' do
        all_merchants.each do |merchant|
          within "#merchant_#{merchant.id}" do
            click_link("#{merchant.name}")
            expect(page).to have_current_path("/admin/merchants/#{merchant.id}")
            visit admin_merchants_path
          end
        end
      end
    end
  end
end