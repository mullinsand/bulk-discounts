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
end