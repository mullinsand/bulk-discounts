require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'validations' do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
    it { should define_enum_for(:status).with_values(["In Progress", "Completed", "Cancelled"])}

  end

  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many :transactions }
  end
    
  describe 'factorybot' do
    it 'instantiates with factorybot' do
      customer = create(:customer)
      invoice = customer.invoices.create(attributes_for(:invoice))
      x = create_list(:invoice, 10, customer: customer)
    end

    it 'instantiates without creating parents' do
      invoice = create(:invoice)
      #calling parents: invoice.customer 
    end

    it 'creates a list of invoices belonging to one customer' do
      customer = create(:customer)
      customer_invoices = create_list(:invoice, 10, customer: customer)
    end

    it 'creates a list of 10 customers' do
      customers = create_list(:customer, 10)
    end
  end

  describe 'instance methods' do
    describe 'find_invoice_item(invoice, item)' do
      it 'can find an instance of invoice_item' do
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
    
          @inv_item_4 = create(:invoice_item, invoice: @invs_1[1], item: @items[1]) #this will always belong to @merchants[0]      
          @inv_item_5 = create(:invoice_item, invoice: @invs_2[1], item: @items2[6]) #this will always belong to @merchants[0]      

          expect(@invs_0[1].find_invoice_item(@invs_0[1], @items[1])).to eq [@inv_item_2]
      end
    end
  end

end
