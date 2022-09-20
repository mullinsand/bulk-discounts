require 'rails_helper'

RSpec.describe 'The Admin Invoice Show' do
  before :each do
    @invoices = create_list(:invoice, 20)

    @inv_items_0 = create_list(:invoice_item, 5, invoice: @invoices[0])
    @inv_items_1 = create_list(:invoice_item, 5, invoice: @invoices[1])
    @inv_items_2 = create_list(:invoice_item, 5, invoice: @invoices[2])
    
    visit admin_invoice_path(@invoices[0])
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
            expect(page).to_not have_content(@inv_items_0[2].quantity)
          end
        end
      end
    end

    it 'shows all invoice item prices' do
      visit admin_invoice_path(@invoices[2])
      within("#all_invoice_items") do
        @inv_items_2.each do |ii|
          within("#inv_item_#{ii.id}") do
            expect(page).to have_content(ii.unit_price)
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

  describe 'update invoice status'

    it 'changes a status to In Progress' do
      comp_invoice = create(:invoice, status: 1)
      canc_invoice = create(:invoice, status: 2)

      visit admin_invoice_path(comp_invoice.id)

      expect(page).to have_content("Invoice Status: Completed")

      select("In Progress"), from: "status"
      click_button 'Submit'

      expect(page).to have_content("Invoice Status: In Progress")
      expect(page).to_not have_content("Invoice Status: Completed")
    end

    it 'changes a status to Completed' do
      ip_invoice = create(:invoice, status: 0)
      canc_invoice = create(:invoice, status: 2)

      visit admin_invoice_path(ip_invoice.id)

      expect(page).to have_content("Invoice Status: In Progress")
      
      select("Completed"), from: "status"
      click_button 'Submit'

      expect(page).to have_content("Invoice Status: Completed")
      expect(page).to_not have_content("Invoice Status: In Progress")
    end

    it 'changes a status to Cancelled' do
      ip_invoice = create(:invoice, status: 0)
      comp_invoice = create(:invoice, status: 1)

      visit admin_invoice_path(comp_invoice.id)

      expect(page).to have_content("Invoice Status: Completed")

      select("Cancelled"), from: "status"
      click_button 'Submit'

      expect(page).to have_content("Invoice Status: Cancelled")
      expect(page).to_not have_content("Invoice Status: Completed")
    end

end