require 'rails_helper'

RSpec.describe 'Invoice Show Page' do
  describe 'invoice attributes' do

    before :each do
      @merchant = create(:merchant)
      
      @items_0 = create_list(:item, 10, merchant: @merchant) #full call to customer @merchants[0].items[0].invoice_items[0].invoice.customer
      @items_1 = create_list(:item, 10, merchant: @merchant)
  
      @customers = create_list(:customer, 2)
  
      @invs_0 = create_list(:invoice, 3, customer: @customers[0]) #
      @invs_1 = create_list(:invoice, 2, customer: @customers[1])
  
      @inv_item_1 = create(:invoice_item, invoice: @invs_0[0], item: @items_0[0]) #this will always belong to @merchants[0]
      @inv_item_2 = create(:invoice_item, invoice: @invs_0[1], item: @items_0[1]) #this will always belong to @merchants[0]
      @inv_item_3 = create(:invoice_item, invoice: @invs_0[2], item: @items_0[2]) #this will always belong to @merchants[0]      
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
  end
end