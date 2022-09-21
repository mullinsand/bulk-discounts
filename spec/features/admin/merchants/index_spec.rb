require 'rails_helper'

RSpec.describe 'Admin Merchants Index' do
  describe "A list of all merchants' names" do
    it 'shows the names of each merchant' do
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
            expect(page).to have_content("#{merchant.name}")
          end
        end
      end
    end

    it 'has each merchant name is a link to the admin merchant show page' do
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
    describe 'under section for enabled merchants' do
      it 'only enabled merchants are shown' do
        merch1 = Merchant.create!(name: Faker::Name.name, status: 0)
        merch2 = Merchant.create!(name: Faker::Name.name, status: 1)
        merch3 = Merchant.create!(name: Faker::Name.name, status: 0)
        merch4 = Merchant.create!(name: Faker::Name.name, status: 1)
        merch5 = Merchant.create!(name: Faker::Name.name, status: 0)

        enabled_merchants = [merch1, merch3, merch5]

        expect(Merchant.enabled_merchants).to eq(enabled_merchants)

        visit admin_merchants_path

        within '#enabled_merchants' do
          enabled_merchants.each do |merchant|
            within "#merchant_#{merchant.id}" do
              expect(page).to have_content(merchant.name)
              expect(page).to_not have_content(merch2.name)
              expect(page).to_not have_content(merch4.name)
            end
          end
        end
      end

      it 'only disabled buttons are shown' do
        merch1 = Merchant.create!(name: Faker::Name.name, status: 0)
        merch2 = Merchant.create!(name: Faker::Name.name, status: 1)
        merch3 = Merchant.create!(name: Faker::Name.name, status: 0)
        merch4 = Merchant.create!(name: Faker::Name.name, status: 1)
        merch5 = Merchant.create!(name: Faker::Name.name, status: 0)

        enabled_merchants = [merch1, merch3, merch5]

        expect(Merchant.enabled_merchants).to eq(enabled_merchants)

        visit admin_merchants_path

        within '#enabled_merchants' do
          enabled_merchants.each do |merchant|
            within "#merchant_#{merchant.id}" do
              expect(page).to have_button("Disable")
              expect(page).to_not have_button("Enable")
            end
          end
        end
      end

      it 'clicking disable button, returns to index with merchant now in disabled merchants list' do
        merch1 = Merchant.create!(name: Faker::Name.name, status: 0)
        merch2 = Merchant.create!(name: Faker::Name.name, status: 1)
        merch3 = Merchant.create!(name: Faker::Name.name, status: 0)
        merch4 = Merchant.create!(name: Faker::Name.name, status: 1)
        merch5 = Merchant.create!(name: Faker::Name.name, status: 0)

        enabled_merchants = [merch1, merch3, merch5]

        visit admin_merchants_path

        within '#enabled_merchants' do
          enabled_merchants.each do |merchant|
            within "#merchant_#{merchant.id}" do
              click_button("Disable")
              expect(current_path).to eq(admin_merchants_path)
            end
          end
          enabled_merchants.each do |merchant|
            expect(page).to_not have_css("#merchant_#{merchant.id}")
          end
        end
        within '#disabled_merchants' do
          enabled_merchants.each do |merchant|
            within "#merchant_#{merchant.id}" do
              expect(page).to have_content(merchant.name)
            end
          end
        end
      end
    end
    describe 'under section for disabled merchants' do
      it 'only disabled merchants are shown' do
        merch1 = Merchant.create!(name: Faker::Name.name, status: 0)
        merch2 = Merchant.create!(name: Faker::Name.name, status: 1)
        merch3 = Merchant.create!(name: Faker::Name.name, status: 0)
        merch4 = Merchant.create!(name: Faker::Name.name, status: 1)
        merch5 = Merchant.create!(name: Faker::Name.name, status: 0)

        disabled_merchants = [merch2, merch4]

        expect(Merchant.disabled_merchants).to eq(disabled_merchants)

        visit admin_merchants_path

        within '#disabled_merchants' do
          disabled_merchants.each do |merchant|
            within "#merchant_#{merchant.id}" do
              expect(page).to have_content(merchant.name)
              expect(page).to_not have_content(merch1.name)
              expect(page).to_not have_content(merch3.name)
            end
          end
        end
      end

      it 'only enabled buttons are shown' do
        merch1 = Merchant.create!(name: Faker::Name.name, status: 0)
        merch2 = Merchant.create!(name: Faker::Name.name, status: 1)
        merch3 = Merchant.create!(name: Faker::Name.name, status: 0)
        merch4 = Merchant.create!(name: Faker::Name.name, status: 1)
        merch5 = Merchant.create!(name: Faker::Name.name, status: 0)

        disabled_merchants = [merch2, merch4]


        expect(Merchant.disabled_merchants).to eq(disabled_merchants)

        visit admin_merchants_path

        within '#disabled_merchants' do
          disabled_merchants.each do |merchant|
            within "#merchant_#{merchant.id}" do
              expect(page).to have_button("Enable")
              expect(page).to_not have_button("Disable")
            end
          end
        end
      end

      it 'clicking disable button, returns to index with merchant now in disabled merchants list' do
        merch1 = Merchant.create!(name: Faker::Name.name, status: 0)
        merch2 = Merchant.create!(name: Faker::Name.name, status: 1)
        merch3 = Merchant.create!(name: Faker::Name.name, status: 0)
        merch4 = Merchant.create!(name: Faker::Name.name, status: 1)
        merch5 = Merchant.create!(name: Faker::Name.name, status: 0)

        disabled_merchants = [merch2, merch4]


        visit admin_merchants_path

        within '#disabled_merchants' do
          disabled_merchants.each do |merchant|
            within "#merchant_#{merchant.id}" do
              click_button("Enable")
              expect(current_path).to eq(admin_merchants_path)
            end
          end
          disabled_merchants.each do |merchant|
            expect(page).to_not have_css("#merchant_#{merchant.id}")
          end
        end
        within '#enabled_merchants' do
          disabled_merchants.each do |merchant|
            within "#merchant_#{merchant.id}" do
              expect(page).to have_content(merchant.name)
            end
          end
        end
      end
    end
  end

  describe 'Top 5 Merchants by Revenue' do
    before :each do
      #this makes 500 records in the DB!!!
      @merchants = create_list(:merchant, 10)
      revenue_fix = 0
      transac_result = 0
      @merchants.each do |merchant|
        transac_result = 1 if revenue_fix == 9
        merch_items = create_list(:item, 10, merchant: merchant)
        merch_invoices = create_list(:invoice, 10)
        merch_invoices.each do |merch_invoice|
          create(:transaction, result: transac_result, invoice: merch_invoice)
          create(:transaction, result: 1, invoice: merch_invoice)
        end
        n = 0
        merch_items.each do |merch_item|
          create(:invoice_item, item: merch_item, invoice: merch_invoices[n], unit_price: revenue_fix, quantity: revenue_fix)
          n += 1
        end
        revenue_fix += 1
      end
      visit '/admin/merchants'
    end

    it 'see the names of the top 5 merchants by total revenue generated' do
      top_five_merchants = [ @merchants[8], @merchants[7], @merchants[6], @merchants[5], @merchants[4] ]
      within("#top_five_merchants") do
        top_five_merchants.each do |merchant|
          within "#top_merchant_#{merchant.id}" do
            expect(page).to have_content(merchant.name)
          end
        end
        expect(page).to_not have_content(@merchants.first.name)
      end
    end

    it 'next to each merchant name is their total revenue' do
      best_merchants = Merchant.top_five_merchants
      revenue_array = best_merchants.map(&:revenue)
      within("#top_five_merchants") do
        best_merchants.each do |merchant|
          within "#top_merchant_#{merchant.id}" do
            rev_in_dollars = "$#{((revenue_array[best_merchants.find_index(merchant)].to_f)/100).round(2)}"
            expect(page).to have_content(rev_in_dollars)
          end
        end
      end
    end

    it 'each merchant name is a link to admin merchant show page' do
      top_five_merchants = [ @merchants[8], @merchants[7], @merchants[6], @merchants[5], @merchants[4] ]
      within("#top_five_merchants") do
        top_five_merchants.each do |merchant|
          within "#top_merchant_#{merchant.id}" do
            click_link(merchant.name)
            expect(current_path).to eq(admin_merchant_path(merchant))
            visit '/admin/merchants'
          end
        end
      end
    end

    it 'has a label for each merchant name listing their best day and revenue from that day' do
      top_five_merchants = [ @merchants[8], @merchants[7], @merchants[6], @merchants[5], @merchants[4] ]
      within("#top_five_merchants") do
        top_five_merchants.each do |merchant|
          within "#top_merchant_#{merchant.id}" do
            within "#best_day_merchant_#{merchant.id}" do
              best_date = merchant.best_selling_day.sale_date.to_date
              expect(page).to have_content("Top selling date for #{merchant.name} was #{best_date}")
            end
          end
        end
      end
    end
  end
end