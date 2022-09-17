require 'rails_helper'

RSpec.describe 'The Admin Invoice Show' do
  before :each do
    @invoices = create_list(:invoice, 20)
    visit admin_invoice_path(@invoices[0])
  end

  it 'shows the invoice ID' do
    expect(page).to have_content(@invoices[0].id)
    expect(page).to_not have_content(@invoices[1].id)
  end

  xit 'shows the invoice status' do
    expect(page).to have_content(@invoices[0].status)
  end

  xit 'shows the invoices created at date in the correct format' do
    expect(page).to have_content(@invoices[0].created_at.strftime("%A, %B %d, %Y"))
  end

  xit 'shows the invoice customers first and last name' do
    expect(page).to have_content(@invoices[0].customer.first_name)
    expect(page).to have_content(@invoices[0].customer.last_name)
  end

end