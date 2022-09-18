require 'rails_helper'

RSpec.describe 'Invoice Show Page' do
  describe 'invoice attributes' do

    before :each do
      @merchant = create(:merchant)
      @merchant2 = create(:merchant)
      
      @items = create_list(:item, 10, merchant: @merchant)
      @items2 = create_list(:item, 10, merchant: @merchant2)
  
      @customers = create_list(:customer, 2)
      @customer = create(:customer)
  
      @invs_0 = create_list(:invoice, 3, customer: @customers[0]) #
      @invs_1 = create_list(:invoice, 2, customer: @customers[1])
      @invs_2 = create_list(:invoice, 2, customer: @customer)
  
      @inv_item_1 = create(:invoice_item, invoice: @invs_0[0], item: @items[0]) #this will always belong to @merchants[0]
      @inv_item_2 = create(:invoice_item, invoice: @invs_0[1], item: @items[1]) #this will always belong to @merchants[0]
      @inv_item_3 = create(:invoice_item, invoice: @invs_0[2], item: @items[2]) #this will always belong to @merchants[0]      

      @inv_item_4 = create(:invoice_item, invoice: @invs_2[0], item: @items2[3]) #this will always belong to @merchants[0]      
      @inv_item_5 = create(:invoice_item, invoice: @invs_1[1], item: @items2[6]) #this will always belong to @merchants[0]      
    end

    it 'can navigate to the show page from the index page' do
      visit merchant_invoices_path(@merchant)

      within "#invoice-#{@invs_0[0].id}" do
        click_link "#{@invs_0[0].id}"
        expect(current_path).to eq merchant_invoice_path(@merchant, @invs_0[0])
      end
    end

    it 'has the invoice information' do
      visit merchant_invoice_path(@merchant, @invs_0[0])

      within ".invoice" do
        expect(page).to have_content("#{@invs_0[0].id}")
        expect(page).to have_content("#{@invs_0[0].status}")
        expect(page).to have_content("#{@invs_0[0].created_at.strftime("%A, %B %d, %Y")}")
        expect(page).to have_content("#{@invs_0[0].customer.first_name} #{@invs_0[0].customer.last_name}")
      end

    end

    it 'shows the items that are associated with the invoice' do
      visit merchant_invoice_path(@merchant, @invs_0[0])

      within ".items" do
        within "#item-#{@items[0].id}" do
          expect(page).to have_content("#{@items[0].name}")
          expect(page).to have_content("#{@inv_item_1.quantity}")
          expect(page).to have_content("$#{((@items[0].unit_price.to_f) / 100).round(3)}")
          expect(page).to have_content("#{@inv_item_1.status}")
        end
      end

      within ".items" do
        expect(page).to_not have_content("#{@invs_2[0].id}")
        expect(page).to_not have_content("#{@invs_2[1].id}")
      end
    end

  end
end