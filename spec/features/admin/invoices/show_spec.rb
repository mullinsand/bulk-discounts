require 'rails_helper'

RSpec.describe 'The Admin Invoice Show' do
  before :each do
    @invoices = create_list(:invoice, 20)
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
    it 'shows all invoice item names on the invoice' do
      

    end
  end

end