require 'rails_helper'

RSpec.describe 'Bulk discount Edit' do
  before :each do
    @merch1 = create(:merchant)
    @bulk_discount_1 = create(:bulk_discount, discount: 75, threshold: 500, merchant: @merch1)
    @bulk_discount_2 = create(:bulk_discount, merchant: @merch1)
    @bulk_discount_3 = create(:bulk_discount, merchant: @merch1)
    @bulk_discount_4 = create(:bulk_discount, merchant: @merch1)
    @bulk_discount_5 = create(:bulk_discount)
  end
  describe "Can update bulk discount attributes" do
    it 'has a link to update bulk discount info' do

      visit merchant_bulk_discount_path(@merch1.id, @bulk_discount_1)

      click_link("Edit Bulk Discount")
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merch1.id, @bulk_discount_1))
    end
  end

  describe "on page, the form is already filled in with the bulk discount's attributes" do
    it 'discount and threshold are prefilled' do

      visit merchant_bulk_discount_path(@merch1.id, @bulk_discount_1)

      within "#discount_#{@bulk_discount_1.id}" do
        expect(page).to have_content(@bulk_discount_1.discount)
        expect(page).to have_content(@bulk_discount_1.threshold)
      end
      click_link("Edit Bulk Discount")
      click_button("Update Bulk discount")
      within "#discount_#{@bulk_discount_1.id}" do
        expect(page).to have_content(@bulk_discount_1.discount)
        expect(page).to have_content(@bulk_discount_1.threshold)
      end
    end 
  end

  describe 'when info is updated and form submitted, returned back to show page to see changes' do
    it 'filling form out and submitting returns back to show page with changes visible' do
      visit merchant_bulk_discount_path(@merch1.id, @bulk_discount_1)
      within "#discount_#{@bulk_discount_1.id}" do
        expect(page).to have_content(75)
        expect(page).to have_content(500)
      end
      click_link("Edit Bulk Discount")
      fill_in :bulk_discount_discount, with: 50
      fill_in :bulk_discount_threshold, with: 100
      click_button("Update Bulk discount")

      within "#discount_#{@bulk_discount_1.id}" do
        expect(page).to have_content(50)
        expect(page).to have_content(100)
      end
    end
  end
end