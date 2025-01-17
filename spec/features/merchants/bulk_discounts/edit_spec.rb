require 'rails_helper'

RSpec.describe 'Bulk discount Edit' do
  VCR.insert_cassette("holiday_data", :allow_playback_repeats => true)
  before :each do
    @merch1 = create(:merchant)
    @bulk_discount_1 = create(:bulk_discount, discount: 75, threshold: 500, merchant: @merch1)
    @bulk_discount_2 = create(:bulk_discount, discount: 5, threshold: 100, merchant: @merch1)
    @bulk_discount_3 = create(:bulk_discount, discount: 10, threshold: 200, merchant: @merch1)
    @bulk_discount_4 = create(:bulk_discount, discount: 15, threshold: 300, merchant: @merch1)
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

    context 'when info is not added correctly' do
      it 'not filling in fields properly returns back to edit page with error message' do
        visit merchant_bulk_discount_path(@merch1.id, @bulk_discount_1)
        click_link("Edit Bulk Discount")
        fill_in :bulk_discount_discount, with: 101
        fill_in :bulk_discount_threshold, with: 100
        click_button("Update Bulk discount")
        expect(current_path).to eq(edit_merchant_bulk_discount_path(@merch1.id, @bulk_discount_1))
        expect(page).to have_content("Error: Discount must be less than or equal to 100")
      end
    end

    context 'cannot update bulk discount if applied to an item with an in progess invoice' do
      it 'displays sad path message when attempting to update an item with in-progress invoice' do
        shady_merchant = create(:merchant)
        in_progress_invoice = create(:invoice, status: 0)
        item_with_discount = create(:item, merchant: shady_merchant)
        invoice_item_pending = create(:invoice_item, invoice: in_progress_invoice, item: item_with_discount, quantity: 4)
        discount_with_invoice = create(:bulk_discount, threshold: 2, merchant: shady_merchant)
        visit merchant_bulk_discount_path(shady_merchant, discount_with_invoice)
        click_link("Edit Bulk Discount")
        # click_button("Update Bulk discount")
        expect(page).to have_current_path(merchant_bulk_discount_path(shady_merchant, discount_with_invoice))
        expect(page).to have_content("Cannot update discount #{discount_with_invoice.id} because it has been applied to a pending invoice")
      end
    end
  end
  VCR.eject_cassette
end