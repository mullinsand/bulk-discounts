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
      @inv_item_3 = create(:invoice_item, invoice: @invs_0[0], item: @items[2]) #this will always belong to @merchants[0]      
      @inv_item_4 = create(:invoice_item, invoice: @invs_0[0], item: @items[3]) #this will always belong to @merchants[0]      
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

  describe 'link to applied discounts' do
    before :each do
      @merchant = create(:merchant)

      @bulk_discount_1 = create(:bulk_discount, threshold: 2, discount: 20,merchant: @merchant)
      @bulk_discount_2 = create(:bulk_discount, threshold: 4, discount: 40,merchant: @merchant)
      @bulk_discount_3 = create(:bulk_discount, threshold: 6, discount: 40,merchant: @merchant)
      @bulk_discount_4 = create(:bulk_discount, threshold: 8, discount: 50,merchant: @merchant)
    
      @items = create_list(:item, 3, merchant: @merchant)
      @inv = create(:invoice)
      #merchant has 2 items that qualify for discounts on this invoice
      @inv_item_1 = create(:invoice_item, invoice: @inv, item: @items[0], unit_price: 500, quantity: 1)
      @inv_item_2 = create(:invoice_item, invoice: @inv, item: @items[1], unit_price: 300, quantity: 5)
      @inv_item_3 = create(:invoice_item, invoice: @inv, item: @items[2], unit_price: 200, quantity: 9) 
      @other_merchant = create(:merchant)
      @items_2 = create_list(:item, 2, merchant: @other_merchant)
      #other merchant has 1 item that qualifies for discounts
      @inv_item_4 = create(:invoice_item, invoice: @inv, item: @items_2[0], unit_price: 100, quantity: 9)
      @inv_item_5 = create(:invoice_item, invoice: @inv, item: @items_2[1], unit_price: 400, quantity: 9)
      @bulk_discount_5 = create(:bulk_discount, threshold: 3, discount: 50,merchant: @other_merchant)
      @bulk_discount_6 = create(:bulk_discount, threshold: 4, discount: 80,merchant: @other_merchant)

      visit merchant_invoice_path(@merchant, @inv)
    end

    it 'if applicable, underneath each listed item is a link to the applied discount show page' do
      within ".items" do
        within "#item-#{@items[1].id}" do
          expect(page).to have_link("#{@bulk_discount_2.discount}% Discount Applied")
        end
        within "#item-#{@items[2].id}" do
          expect(page).to have_link("#{@bulk_discount_4.discount}% Discount Applied")
        end
      end
    end

    context 'when no discount is applicable' do
      it 'says nothing' do
        within ".items" do
          within "#item-#{@items[0].id}" do
            expect(page).to_not have_content("Discount Applied")
          end
        end
      end
    end
  end

  describe 'total_revenue and discounted revenue' do
    before :each do
      @merchant = create(:merchant)


      @bulk_discount_1 = create(:bulk_discount, threshold: 2, discount: 20,merchant: @merchant)
      @bulk_discount_2 = create(:bulk_discount, threshold: 4, discount: 40,merchant: @merchant)
      @bulk_discount_3 = create(:bulk_discount, threshold: 6, discount: 40,merchant: @merchant)
      @bulk_discount_4 = create(:bulk_discount, threshold: 8, discount: 50,merchant: @merchant)
    
      @items = create_list(:item, 3, merchant: @merchant)
      @inv = create(:invoice)
      #merchant has 2 items that qualify for discounts on this invoice
      @inv_item_1 = create(:invoice_item, invoice: @inv, item: @items[0], unit_price: 500, quantity: 1)
      @inv_item_2 = create(:invoice_item, invoice: @inv, item: @items[1], unit_price: 300, quantity: 5)
      @inv_item_3 = create(:invoice_item, invoice: @inv, item: @items[2], unit_price: 200, quantity: 9) 
      @other_merchant = create(:merchant)
      @items_2 = create_list(:item, 2, merchant: @other_merchant)
      #other merchant has 2 items that qualifies for discounts
      @inv_item_4 = create(:invoice_item, invoice: @inv, item: @items_2[0], unit_price: 100, quantity: 9)
      @inv_item_5 = create(:invoice_item, invoice: @inv, item: @items_2[1], unit_price: 400, quantity: 9)
      @bulk_discount_5 = create(:bulk_discount, threshold: 3, discount: 50,merchant: @other_merchant)
      @bulk_discount_6 = create(:bulk_discount, threshold: 4, discount: 80,merchant: @other_merchant)
    end

    it 'shows the total revenue earned by the merchant from the invoice' do
      visit merchant_invoice_path(@merchant, @inv)
      within '#total_revenue' do
        expect(page).to have_content("Total Revenue:")
        expect(page).to have_content("$38.00")
      end
    end

    it 'shows the total discounted revenue earned by the merchant from the invoice' do
      visit merchant_invoice_path(@merchant, @inv)
      within '#total_disco_revenue' do
        expect(page).to have_content("Total Discounted Revenue:")
        expect(page).to have_content("$23.00")
      end
    end

    context 'if merchant has no applicable bulk discounts' do
      it 'does not populate the page with a total discounted revenue' do
        no_disco_invoice = create(:invoice)
        other_merchant = create(:merchant)
        items_2 = create_list(:item, 2, merchant: other_merchant)
        #other merchant has 1 item that qualifies for discounts
        inv_item_4 = create(:invoice_item, invoice: no_disco_invoice, item: items_2[0], unit_price: 1, quantity: 9)
        inv_item_5 = create(:invoice_item, invoice: no_disco_invoice, item: items_2[1], unit_price: 4, quantity: 9)
        bulk_discount_5 = create(:bulk_discount, threshold: 50, discount: 50,merchant: other_merchant)
        bulk_discount_6 = create(:bulk_discount, threshold: 200, discount: 80,merchant: other_merchant)
        visit merchant_invoice_path(other_merchant, no_disco_invoice)
        expect(page).to_not have_css('#total_disco_revenue')
        expect(page).to_not have_content("Total Discounted Revenue:")
        expect(page).to_not have_content("$23.00")
        expect(page).to have_content("No Bulk Discounts Applied")
      end
    end  

    context 'if merchant has no bulk discounts' do
      it 'does not populate the page with a total discounted revenue' do
        no_disco_invoice = create(:invoice)
        other_merchant = create(:merchant)
        items_2 = create_list(:item, 2, merchant: other_merchant)
        #other merchant has 1 item that qualifies for discounts
        inv_item_4 = create(:invoice_item, invoice: no_disco_invoice, item: items_2[0], unit_price: 1, quantity: 9)
        inv_item_5 = create(:invoice_item, invoice: no_disco_invoice, item: items_2[1], unit_price: 4, quantity: 9)
        visit merchant_invoice_path(other_merchant, no_disco_invoice)
        expect(page).to_not have_css('#total_disco_revenue')
        expect(page).to_not have_content("Total Discounted Revenue:")
        expect(page).to_not have_content("$23.00")
        expect(page).to have_content("No Bulk Discounts Applied")
      end
    end  
  end

  describe 'update item status' do

    before :each do
      @merchant = create(:merchant)

      @customer = create(:customer)
      
      @item = create(:item, merchant: @merchant, unit_price: 100)
      @item_2 = create(:item, merchant: @merchant, unit_price: 100)
      @item_3 = create(:item, merchant: @merchant, unit_price: 100)

      @invoice = create(:invoice, customer: @customer, status: 1)

      @invoice_items = create(:invoice_item, item: @item, invoice: @invoice, unit_price: @item.unit_price, status: 0) #pending
      @invoice_items = create(:invoice_item, item: @item_2, invoice: @invoice, unit_price: @item_2.unit_price, status: 1) #packaged
      @invoice_items = create(:invoice_item, item: @item_3, invoice: @invoice, unit_price: @item_3.unit_price, status: 2) #shipped
    end

    it 'can change the item status to Packaged' do
      visit merchant_invoice_path(@merchant, @invoice)

      within ".items" do
        within "#item-#{@item.id}" do
          expect(page).to have_content("Invoice Status: Pending")
            within "#status-update-#{@item.id}" do
              select 'Packaged', from: "status"
              click_button 'Submit'
              expect(current_path).to eq merchant_invoice_path(@merchant, @invoice)
            end
          expect(page).to_not have_content("Invoice Status: Pending")
          expect(page).to have_content("Invoice Status: Packaged")
        end
      end
    end

    it 'can change the item status to Pending' do
      visit merchant_invoice_path(@merchant, @invoice)

      within ".items" do
        within "#item-#{@item_3.id}" do
          expect(page).to have_content("Invoice Status: Shipped")
            within "#status-update-#{@item_3.id}" do
              select 'Packaged', from: "status"
              click_button 'Submit'
              expect(current_path).to eq merchant_invoice_path(@merchant, @invoice)
            end
          expect(page).to_not have_content("Invoice Status: Pending")
          expect(page).to have_content("Invoice Status: Packaged")
        end
      end
    end

    it 'can change the item status to Shipped' do
      visit merchant_invoice_path(@merchant, @invoice)

      within ".items" do
        within "#item-#{@item_2.id}" do
          expect(page).to have_content("Invoice Status: Packaged")
            within "#status-update-#{@item_2.id}" do
              select 'Packaged', from: "status"
              click_button 'Submit'
              expect(current_path).to eq merchant_invoice_path(@merchant, @invoice)
            end
          expect(page).to_not have_content("Invoice Status: Pending")
          expect(page).to have_content("Invoice Status: Packaged")
        end
      end
    end

  end
end