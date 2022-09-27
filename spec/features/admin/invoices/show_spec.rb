require 'rails_helper'

RSpec.describe 'The Admin Invoice Show' do
  before :each do
    @invoices = create_list(:invoice, 20)

    @inv_items_0 = create_list(:invoice_item, 5, invoice: @invoices[0])
    @inv_items_1 = create_list(:invoice_item, 5, invoice: @invoices[1])
    @inv_items_2 = create_list(:invoice_item, 5, invoice: @invoices[2])
    visit admin_invoice_path(@invoices[0])
    @inv_extra = create(:invoice)
    @inv_extra_inv_items = create_list(:invoice_item, 3, unit_price: 500, invoice: @inv_extra, quantity: 2)
  end
  
  describe 'invoice info section' do
    it 'shows the invoice ID' do
      within("#invoice_info") do
        @invoices.each do |inv|
          visit admin_invoice_path(inv)
          expect(page).to have_content(inv.id)
        end
      end
    end

    it 'shows the invoice status' do
      within("#invoice_info") do
        @invoices.each do |inv|
          visit admin_invoice_path(inv)
          expect(page).to have_content(inv.status)
        end
      end
    end

    it 'shows the invoices created at date in the correct format' do
      within("#invoice_info") do
        @invoices.each do |inv|
          visit admin_invoice_path(inv)
          expect(page).to have_content(inv.created_at.strftime("%A, %B %d, %Y"))
        end
      end
    end

    it 'shows the invoice customers first and last name' do
      within("#invoice_info") do
        @invoices.each do |inv|
          visit admin_invoice_path(inv)
          expect(page).to have_content(inv.customer.first_name)
          expect(page).to have_content(inv.customer.last_name)
        end
      end
    end

    it 'shows the total revenue in dollars' do
      visit admin_invoice_path(@inv_extra)
      within("#invoice_info") do
        expect(page).to have_content("Total Revenue: $30.00")
      end
    end
  end

  describe 'invoice item information section' do
    it 'shows all item names' do
      within("#all_invoice_items") do
        @inv_items_0.each do |ii|
          within("#inv_item_#{ii.id}") do
            expect(page).to have_content(ii.item.name)
            expect(page).to_not have_content(@inv_items_1[0].item.name)
          end
        end
      end
    end

    it 'shows all invoice item quantities' do
      visit admin_invoice_path(@invoices[1])
      within("#all_invoice_items") do
        @inv_items_1.each do |ii|
          within("#inv_item_#{ii.id}") do
            expect(page).to have_content(ii.quantity)
          end
        end
      end
    end

    it 'shows all invoice item prices' do
      visit admin_invoice_path(@invoices[2])
      within("#all_invoice_items") do
        @inv_items_2.each do |ii|
          within("#inv_item_#{ii.id}") do
            expect(page).to have_content(ii.item.current_price)
            expect(page).to_not have_content(@inv_items_0[3].unit_price)
          end
        end
      end
    end

    it 'shows all invoice item statuses' do
      visit admin_invoice_path(@invoices[2])
      within("#all_invoice_items") do
        @inv_items_2.each do |ii|
          within("#inv_item_#{ii.id}") do
            expect(page).to have_content(ii.status)
          end
        end
      end
    end
  end

  describe 'update invoice status' do

    it 'changes a status to In Progress' do
      within("#invoice_info") do
        comp_invoice = create(:invoice, status: 1)
        canc_invoice = create(:invoice, status: 2)

        visit admin_invoice_path(comp_invoice.id)

        expect(page).to have_content("Status: Completed")

        select("In Progress")
        click_button 'Submit'

        expect(current_path).to eq(admin_invoice_path(comp_invoice.id))
        expect(page).to have_content("Status: In Progress")
        expect(page).to_not have_content("Status: Completed")
      end
    end

    it 'changes a status to Completed' do
      within("#invoice_info") do
        ip_invoice = create(:invoice, status: 0)
        canc_invoice = create(:invoice, status: 2)

        visit admin_invoice_path(ip_invoice.id)
        
        expect(page).to have_content("Status: In Progress")
        
        select("Completed")
        click_button 'Submit'

        expect(current_path).to eq(admin_invoice_path(ip_invoice.id))
        expect(page).to have_content("Status: Completed")
      end
    end

    it 'changes a status to Cancelled' do
      within("#invoice_info") do
        ip_invoice = create(:invoice, status: 0)
        comp_invoice = create(:invoice, status: 1)

        visit admin_invoice_path(comp_invoice.id)
        

        expect(page).to have_content("Status: Completed")

        select("Cancelled")
        click_button 'Submit'

        expect(current_path).to eq(admin_invoice_path(comp_invoice.id))
        expect(page).to have_content("Status: Cancelled")
        expect(page).to_not have_content("Status: Completed")
      end
    end

    it 'button defaults to the invoice status' do
      within("#invoice_info") do
        ip_invoice = create(:invoice, status: 0)
        visit admin_invoice_path(ip_invoice.id)

        expect(page).to have_content("Status: In Progress")
        
        click_button 'Submit'

        expect(current_path).to eq(admin_invoice_path(ip_invoice.id))
        expect(page).to have_content("Status: In Progress")
      end
    end
  end

  describe 'admin invoice total_revenue and discounted revenue' do
    before :each do
      @merchant = create(:merchant)


      @bulk_discount_1 = create(:bulk_discount, threshold: 2, discount: 20,merchant: @merchant)
      @bulk_discount_2 = create(:bulk_discount, threshold: 4, discount: 40,merchant: @merchant)
      @bulk_discount_3 = create(:bulk_discount, threshold: 6, discount: 41,merchant: @merchant)
      @bulk_discount_4 = create(:bulk_discount, threshold: 8, discount: 50,merchant: @merchant)
    
      @items = create_list(:item, 3, merchant: @merchant)
      @inv = create(:invoice)
      #merchant has 2 items that qualify for discounts on this invoice
      @inv_item_1 = create(:invoice_item, invoice: @inv, item: @items[0], unit_price: 500, quantity: 1)
      @inv_item_2 = create(:invoice_item, invoice: @inv, item: @items[1], unit_price: 300, quantity: 5)
      @inv_item_3 = create(:invoice_item, invoice: @inv, item: @items[2], unit_price: 200, quantity: 9) 
      @other_merchant = create(:merchant)
      @items_2 = create_list(:item, 3, merchant: @other_merchant)
      @bulk_discount_5 = create(:bulk_discount, threshold: 3, discount: 25,merchant: @other_merchant)
      @bulk_discount_6 = create(:bulk_discount, threshold: 4, discount: 50,merchant: @other_merchant)
      #other merchant has 2 items that qualifies for discounts
      @inv_item_4 = create(:invoice_item, invoice: @inv, item: @items_2[0], unit_price: 100, quantity: 9)
      @inv_item_5 = create(:invoice_item, invoice: @inv, item: @items_2[1], unit_price: 400, quantity: 9)
      @inv_item_6 = create(:invoice_item, invoice: @inv, item: @items_2[2], unit_price: 100, quantity: 2)

      #total invoice revenue = 47 + 38 = $85
      #total discount = 15 + 22.5 = $37.5
      #total discount revenue = $47.5
      visit admin_invoice_path(@inv)
    end

    it 'shows the total revenue earned on the invoice' do
      within '#total_revenue' do
        expect(page).to have_content("Total Revenue:")
        expect(page).to have_content("$85.00")
      end
    end

    it 'shows the total discounted revenue earned from the invoice' do
      within '#total_disco_revenue' do
        expect(page).to have_content("Total Discounted Revenue:")
        expect(page).to have_content("$47.50")
      end
    end

    context 'if merchant has no applicable bulk discounts' do
      it 'does not populate the page with a total discounted revenue' do
        no_disco_invoice = create(:invoice)
        other_merchant = create(:merchant)
        items_2 = create_list(:item, 2, merchant: other_merchant)
        inv_item_4 = create(:invoice_item, invoice: no_disco_invoice, item: items_2[0], unit_price: 1, quantity: 9)
        inv_item_5 = create(:invoice_item, invoice: no_disco_invoice, item: items_2[1], unit_price: 4, quantity: 9)
        bulk_discount_5 = create(:bulk_discount, threshold: 50, discount: 50,merchant: other_merchant)
        bulk_discount_6 = create(:bulk_discount, threshold: 200, discount: 80,merchant: other_merchant)
        visit merchant_invoice_path(other_merchant, no_disco_invoice)

        expect(page).to_not have_css('#total_disco_revenue')
        expect(page).to_not have_content("Total Discounted Revenue:")
        expect(page).to have_content("No Bulk Discounts Applied")
      end
    end  

    context 'if merchant has no bulk discounts' do
      it 'does not populate the page with a total discounted revenue' do
        no_disco_invoice = create(:invoice)
        other_merchant = create(:merchant)
        items_2 = create_list(:item, 2, merchant: other_merchant)
        inv_item_4 = create(:invoice_item, invoice: no_disco_invoice, item: items_2[0], unit_price: 1, quantity: 9)
        inv_item_5 = create(:invoice_item, invoice: no_disco_invoice, item: items_2[1], unit_price: 4, quantity: 9)
        visit merchant_invoice_path(other_merchant, no_disco_invoice)

        expect(page).to_not have_css('#total_disco_revenue')
        expect(page).to_not have_content("Total Discounted Revenue:")
        expect(page).to have_content("No Bulk Discounts Applied")
      end
    end  
  end

  describe 'when a invoice is updated to completed' do
    describe 'it updates all invoice_items associated with it with the appropriate applied discounts' do
      before :each do
        @merchant = create(:merchant)


        @bulk_discount_1 = create(:bulk_discount, threshold: 2, discount: 20,merchant: @merchant)
        @bulk_discount_2 = create(:bulk_discount, threshold: 4, discount: 40,merchant: @merchant)
        @bulk_discount_3 = create(:bulk_discount, threshold: 6, discount: 41,merchant: @merchant)
        @bulk_discount_4 = create(:bulk_discount, threshold: 8, discount: 50,merchant: @merchant)
      
        @items = create_list(:item, 3, merchant: @merchant)
        @inv = create(:invoice, status: "In Progress")
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

      it 'updates only invoice_items that have an applicable bulk discount' do

        expect(@inv_item_2.applied_discount).to eq(0)
        expect(@inv_item_3.applied_discount).to eq(0)
        expect(@inv_item_4.applied_discount).to eq(0)
        expect(@inv_item_5.applied_discount).to eq(0)

        visit admin_invoice_path(@inv)
          
        select("Completed")
        click_button 'Submit'

        expect(InvoiceItem.find(@inv_item_2.id).applied_discount).to eq(40)
        expect(InvoiceItem.find(@inv_item_3.id).applied_discount).to eq(50)
        expect(InvoiceItem.find(@inv_item_4.id).applied_discount).to eq(80)
        expect(InvoiceItem.find(@inv_item_5.id).applied_discount).to eq(80)
      end

      context 'invoice_items that have no applicable bulk discount' do
        it 'leaves the applied discount attribute at 0 (default)' do
          expect(@inv_item_1.applied_discount).to eq(0)
  
          visit admin_invoice_path(@inv)
            
          select("Completed")
          click_button 'Submit'
  
          expect(InvoiceItem.find(@inv_item_1.id).applied_discount).to eq(0)
        end
      end

      it 'updates only invoice_items that are on the invoice' do
        other_invoice = create(:invoice, status: "In Progress")
        other_merchant = create(:merchant)
        items_3 = create_list(:item, 2, merchant: other_merchant)
        #other merchant has 1 item that qualifies for discounts
        inv_item_4 = create(:invoice_item, invoice: other_invoice, item: items_3[0], unit_price: 1, quantity: 9)
        inv_item_5 = create(:invoice_item, invoice: other_invoice, item: items_3[1], unit_price: 4, quantity: 9)
        bulk_discount_5 = create(:bulk_discount, threshold: 5, discount: 50,merchant: other_merchant)
        bulk_discount_6 = create(:bulk_discount, threshold: 200, discount: 80,merchant: other_merchant)

        visit admin_invoice_path(@inv)
          
        select("Completed")
        click_button 'Submit'

        expect(InvoiceItem.find(inv_item_4.id).applied_discount).to eq(0)
        expect(InvoiceItem.find(inv_item_5.id).applied_discount).to eq(0)
      end
    end
  end
end
