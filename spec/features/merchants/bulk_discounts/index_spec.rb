require 'rails_helper'

RSpec.describe 'bulk discounts Index' do
  VCR.insert_cassette("holiday_data", :allow_playback_repeats => true)
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
        expect(page).to_not have_css("#discount_#{bulk_discount_5.id}")
      end
    end

    it 'has each bulk discount is a link to the bulk discount show page' do
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
            click_link("Bulk Discount ##{bulk_discount.id}")
            expect(page).to have_current_path(merchant_bulk_discount_path(bulk_discount.merchant_id, bulk_discount))
            visit merchant_bulk_discounts_path(merch1.id)
          end
        end
      end
    end

    describe 'delete bulk discount' do
      before :each do
        @merch1 = create(:merchant)
        @bulk_discount_1 = create(:bulk_discount, merchant: @merch1)
        @bulk_discount_2 = create(:bulk_discount, merchant: @merch1)
        @bulk_discount_3 = create(:bulk_discount, merchant: @merch1)
        @bulk_discount_4 = create(:bulk_discount, merchant: @merch1)
        @bulk_discount_5 = create(:bulk_discount)

        @all_bulk_discounts = [@bulk_discount_1, @bulk_discount_2, @bulk_discount_3, @bulk_discount_4]
        visit merchant_bulk_discounts_path(@merch1.id)
      end 

      it 'each bulk discount has a button to delete that bulk discount' do
        within '#discounts' do
          @all_bulk_discounts.each do |bulk_discount|
            within "#discount_#{bulk_discount.id}" do
              expect(page).to have_button("Delete")
            end
          end
        end
      end

      it 'pressing delete button returns to index page where bulk discount no longer is' do

        within '#discounts' do
          @all_bulk_discounts.each do |bulk_discount|
            within "#discount_#{bulk_discount.id}" do
              click_button("Delete")
              expect(page).to have_current_path(merchant_bulk_discounts_path(@merch1.id))
            end
            expect(page).to_not have_css("#discount_#{bulk_discount.id}")
          end
        end
      end

      context 'cannot delete bulk discount if applied to an item with an in progess invoice' do
        it 'displays sad path message when attempting to delete an item with in-progress invoice' do
          shady_merchant = create(:merchant)
          discount_with_invoice = create(:bulk_discount, threshold: 2, merchant: shady_merchant)
          in_progress_invoice = create(:invoice, status: 0)
          item_with_discount = create(:item, merchant: shady_merchant)
          invoice_item_pending = create(:invoice_item, invoice: in_progress_invoice, item: item_with_discount, quantity: 4)
          visit merchant_bulk_discounts_path(shady_merchant.id)
          within "#discount_#{discount_with_invoice.id}" do
            click_button("Delete")
            expect(page).to have_current_path(merchant_bulk_discounts_path(shady_merchant.id))
          end
          expect(page).to have_content("Cannot delete discount #{discount_with_invoice.id} because it has been applied to a pending invoice")
        end
      end
    end
  end

  describe 'Upcoming Holidays' do
    before :each do
      @merch1 = create(:merchant)
      @bulk_discount_1 = create(:bulk_discount, merchant: @merch1)
      @bulk_discount_2 = create(:bulk_discount, merchant: @merch1)
      @bulk_discount_3 = create(:bulk_discount, merchant: @merch1)
      @bulk_discount_4 = create(:bulk_discount, merchant: @merch1)
      @bulk_discount_5 = create(:bulk_discount)
      
      @upcoming_vcr_holidays = [
        {name: "Columbus Day",
        date: "2022-10-10"},
        {name: "Veterans Day",
          date: "2022-11-11"},
        {name: "Thanksgiving Day",
          date: "2022-11-24"}
      ]
      visit merchant_bulk_discounts_path(@merch1.id)
    end
    it "has a section with the header 'Upcoming Holidays'" do
      expect(page).to have_content("Upcoming Holidays")
    end

    it "lists the name and date of the next 3 US holidays" do

      within '#holidays' do
        @upcoming_vcr_holidays.each do |holiday|
          within "#holiday-#{holiday[:date]}"
          expect(page).to have_content(holiday[:name])
          expect(page).to have_content(holiday[:date])
        end
      end
    end
  end

  describe 'Holiday Discount' do
    before :each do
      @merch1 = create(:merchant)
      @bulk_discount_1 = create(:bulk_discount, threshold: 100, discount: 10, merchant: @merch1)
      @bulk_discount_2 = create(:bulk_discount, threshold: 150, discount: 11, merchant: @merch1)
      @upcoming_vcr_holidays = [
        {name: "Columbus Day", date: "2022-10-10"},
        {name: "Veterans Day", date: "2022-11-11"},
        {name: "Thanksgiving Day", date: "2022-11-24"}]
      visit merchant_bulk_discounts_path(@merch1.id)
    end
    describe 'I can create new discounts based on the holidays' do
      it 'has a button next to each holiday' do
        within '#holidays' do
          @upcoming_vcr_holidays.each do |holiday|
            within "#discount_#{holiday[:date]}" do
              expect(page).to have_button("Create Holiday Discount!")
            end
          end
        end
      end

      it 'clicking button goes to a new discount form fields auto populated' do
        @upcoming_vcr_holidays.each do |holiday|
          within '#holidays' do
            within "#discount_#{holiday[:date]}" do
              click_button("Create Holiday Discount!")
            end
          end
          expect(page).to have_field(:bulk_discount_name, with: "#{holiday[:name]} discount")
          expect(page).to have_field(:bulk_discount_discount, with: 30)
          expect(page).to have_field(:bulk_discount_threshold, with: 2)

          visit merchant_bulk_discounts_path(@merch1.id)
        end
      end

      it 'form fields can each be edited' do
        within '#holidays' do
          within "#discount_#{@upcoming_vcr_holidays.first[:date]}" do
            click_button("Create Holiday Discount!")
          end
        end
        fill_in :bulk_discount_name, with: "Early Halloween Discount"
        fill_in :bulk_discount_discount, with: 40
        fill_in :bulk_discount_threshold, with: 4
        click_button 'Create Bulk discount'
      end

      it 'submitting form returns merchant to index page where discount is listed' do
        within '#holidays' do
          within "#discount_#{@upcoming_vcr_holidays.first[:date]}" do
            click_button("Create Holiday Discount!")
          end
        end
        fill_in :bulk_discount_name, with: "Early Halloween Discount"
        fill_in :bulk_discount_discount, with: 40
        fill_in :bulk_discount_threshold, with: 4
        click_button 'Create Bulk discount'
        expect(current_path).to eq(merchant_bulk_discounts_path(@merch1.id))
        holiday_discount = BulkDiscount.last
        within '#discounts' do
          within "#discount_#{holiday_discount.id}" do
            expect(page).to have_content(holiday_discount.name)
            expect(page).to have_content(holiday_discount.threshold)
            expect(page).to have_content(holiday_discount.discount)
          end
        end
      end

      it 'after creating a holiday discount, the create holiday discount like changes to a show page link for the discount' do
        within '#holidays' do
          within "#discount_#{@upcoming_vcr_holidays.first[:date]}" do
            click_button("Create Holiday Discount!")
          end
        end
        fill_in :bulk_discount_name, with: "Early Halloween Discount"
        fill_in :bulk_discount_discount, with: 40
        fill_in :bulk_discount_threshold, with: 4
        click_button 'Create Bulk discount'
        holiday_discount = BulkDiscount.last
        within '#holidays' do
          within "#discount_#{@upcoming_vcr_holidays.first[:date]}" do
            click_link "View discount"
            expect(current_path).to eq(merchant_bulk_discount_path(@merch1.id, holiday_discount))
          end
        end
      end
    end

  end
  VCR.eject_cassette
end