require 'rails_helper'

RSpec.describe 'New bulk discounts' do
  before :each do
    @merch1 = create(:merchant)
    @bulk_discount_2 = create(:bulk_discount, merchant: @merch1)
    @bulk_discount_1 = create(:bulk_discount, merchant: @merch1)
    @bulk_discount_3 = create(:bulk_discount, merchant: @merch1)
    @bulk_discount_4 = create(:bulk_discount, merchant: @merch1)
    @bulk_discount_5 = create(:bulk_discount)
  end
  describe "Create a new bulk discount" do
    it 'has a link to create new discount on index page' do
      visit merchant_bulk_discounts_path(@merch1.id)
      expect(page).to have_link("Create New Discount")
    end

    it 'this link takes me to new page with form to add new bulk discount' do
      visit merchant_bulk_discounts_path(@merch1.id)
      click_link("Create New Discount")
      expect(current_path).to eq(new_merchant_bulk_discount_path(@merch1))
    end

    it 'new page has a form to add discount info' do

      visit merchant_bulk_discounts_path(@merch1.id)
      click_link("Create New Discount")

      fill_in :bulk_discount_discount, with: 50
      fill_in :bulk_discount_threshold, with: 100
      click_button 'Create Bulk discount'
    end

    context 'if discount is over 100' do
      it 'returns merchant back to new discount page with sad path flash message' do
        visit merchant_bulk_discounts_path(@merch1.id)
        click_link("Create New Discount")
  
        fill_in :bulk_discount_discount, with: 101
        fill_in :bulk_discount_threshold, with: 100
        click_button 'Create Bulk discount'

        expect(current_path).to eq(new_merchant_bulk_discount_path(@merch1))
        expect(page).to have_content("Error: Discount must be less than or equal to 100")
      end
    end

    it 'filling out form takes merchant back to index page with new discount' do

      visit merchant_bulk_discounts_path(@merch1.id)
      click_link("Create New Discount")

      fill_in :bulk_discount_discount, with: 50
      fill_in :bulk_discount_threshold, with: 100
      click_button 'Create Bulk discount'

      expect(current_path).to eq(merchant_bulk_discounts_path(@merch1.id))

      new_bulk_discount = BulkDiscount.last
      within '#discounts' do
        within "#discount_#{new_bulk_discount.id}" do
          expect(page).to have_content("#{new_bulk_discount.discount}")
          expect(page).to have_content("#{new_bulk_discount.threshold}")
        end
      end
    end
  end
end