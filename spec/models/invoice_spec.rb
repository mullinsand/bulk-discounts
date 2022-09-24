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
    it { should have_many(:bulk_discounts).through(:invoice_items) }
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
    describe 'find_invoice_item_quantity(invoice, item)' do
      it 'can find an instance of invoice_item_quantity' do
          @merchant = create(:merchant)
          @merchant2 = create(:merchant)
          
          @items = create_list(:item, 10, merchant: @merchant)
          @items2 = create_list(:item, 10, merchant: @merchant2)
      
          @customers = create_list(:customer, 2)
          @customer = create(:customer)
      
          @invs_0 = create_list(:invoice, 3, customer: @customers[0]) #
          @invs_1 = create_list(:invoice, 2, customer: @customers[1])
          @invs_2 = create_list(:invoice, 2, customer: @customer)
      
          @inv_item_1 = create(:invoice_item, invoice: @invs_0[0], item: @items[0], quantity: 1) #this will always belong to @merchants[0]
          @inv_item_2 = create(:invoice_item, invoice: @invs_0[1], item: @items[1], quantity: 1) #this will always belong to @merchants[0]
          @inv_item_3 = create(:invoice_item, invoice: @invs_0[2], item: @items[2], quantity: 1) #this will always belong to @merchants[0]      
    
          @inv_item_4 = create(:invoice_item, invoice: @invs_1[1], item: @items[1], quantity: 1) #this will always belong to @merchants[0]      
          @inv_item_5 = create(:invoice_item, invoice: @invs_2[1], item: @items2[6], quantity: 1) #this will always belong to @merchants[0]      

          expect(@invs_0[1].find_invoice_item_quantity(@invs_0[1], @items[1])).to eq 1
      end
    end

    describe 'find_invoice_item_status(invoice, item)' do
      it 'can find an instance of invoice_item_quantity' do
          @merchant = create(:merchant)
          @merchant2 = create(:merchant)
          
          @items = create_list(:item, 10, merchant: @merchant)
          @items2 = create_list(:item, 10, merchant: @merchant2)
      
          @customers = create_list(:customer, 2)
          @customer = create(:customer)
      
          @invs_0 = create_list(:invoice, 3, customer: @customers[0]) #
          @invs_1 = create_list(:invoice, 2, customer: @customers[1])
          @invs_2 = create_list(:invoice, 2, customer: @customer)
      
          @inv_item_1 = create(:invoice_item, invoice: @invs_0[0], item: @items[0], quantity: 1) #this will always belong to @merchants[0]
          @inv_item_2 = create(:invoice_item, invoice: @invs_0[1], item: @items[1], quantity: 1, status: 0) #this will always belong to @merchants[0]
          @inv_item_3 = create(:invoice_item, invoice: @invs_0[2], item: @items[2], quantity: 1) #this will always belong to @merchants[0]      
    
          @inv_item_4 = create(:invoice_item, invoice: @invs_1[1], item: @items[1], quantity: 1) #this will always belong to @merchants[0]      
          @inv_item_5 = create(:invoice_item, invoice: @invs_2[1], item: @items2[6], quantity: 1) #this will always belong to @merchants[0]      

          expect(@invs_0[1].find_invoice_item_status(@invs_0[1], @items[1])).to eq "Pending"
      end
    end

    describe '.revenue' do
      
      before :each do
        @merchant = create(:merchant)

        @customer = create(:customer)
        
        @item = create(:item, merchant: @merchant, unit_price: 100)
        @item_2 = create(:item, merchant: @merchant, unit_price: 100)

        @invoice = create(:invoice, customer: @customer, status: 1)

        @invoice_items = create(:invoice_item, item: @item, invoice: @invoice, unit_price: @item.unit_price, quantity: 1)
        @invoice_items = create(:invoice_item, item: @item_2, invoice: @invoice, unit_price: @item_2.unit_price, quantity: 1)
      end

      it 'can find the sum of each items total revenue for the invoice' do
        expect(@invoice.total_revenue).to eq 200
      end
    end
  end


  describe 'class methods' do
    describe '#incomplete_invoices_sorted' do
      it 'finds invoices that have invoice items that have not been shipped' do
        invoices = create_list(:invoice, 5)
        
        inv_items_0_shipped = create_list(:invoice_item, 5, invoice: invoices[0], status: 2)
       
        inv_items_1_shipped = create_list(:invoice_item, 5, invoice: invoices[1], status: 2)
        inv_items_1_pending= create_list(:invoice_item, 2, invoice: invoices[1], status: 0)
        inv_items_1_packaged = create_list(:invoice_item, 2, invoice: invoices[1], status: 1)

        inv_items_2_shipped = create_list(:invoice_item, 5, invoice: invoices[2], status: 2)

        inv_items_3_pending = create_list(:invoice_item, 5, invoice: invoices[3], status: 0)

        inv_items_4_packaged = create_list(:invoice_item, 5, invoice: invoices[4], status: 1)
        
        expect(Invoice.incomplete_invoices_sorted).to eq([invoices[1], invoices[3], invoices[4]])
      end

      it 'orders invoices with invoice items that have not been shipped by date' do
        oldest_inv = create(:invoice, created_at: 2.day.ago)
        middle_inv = create(:invoice, created_at: Date.today)
        newest_inv = create(:invoice, created_at: Date.tomorrow)
        
        oldest_inv_items = create_list(:invoice_item, 5, invoice: oldest_inv, status: 1)
        middle_inv_items = create_list(:invoice_item, 5, invoice: middle_inv, status: 0)
        newest_inv_items = create_list(:invoice_item, 5, invoice: newest_inv, status: 1)
        
        expect(Invoice.incomplete_invoices_sorted).to eq([oldest_inv, middle_inv, newest_inv])
      end
    end
  end


  describe 'instance methods' do
    describe '#total_invoice_revenue' do
      it 'calculates the total invoice revenue' do
        invoices = create_list(:invoice, 3)

        inv_items_0 = create_list(:invoice_item, 3, invoice: invoices[0], unit_price: 1000, quantity: 1)
        inv_items_1 = create_list(:invoice_item, 3, invoice: invoices[1], unit_price: 2000, quantity: 2)
        inv_items_2 = create_list(:invoice_item, 3, invoice: invoices[2], unit_price: 3000, quantity: 3)
        
        expect(invoices[0].total_invoice_revenue).to eq(3000)
        expect(invoices[1].total_invoice_revenue).to eq(12000)
        expect(invoices[2].total_invoice_revenue).to eq(27000)
      end
    end

    it 'calculates total invoice revenue in dollars' do
      invoices = create_list(:invoice, 3)

      inv_items_0 = create_list(:invoice_item, 3, invoice: invoices[0], unit_price: 1000, quantity: 1)
      inv_items_1 = create_list(:invoice_item, 3, invoice: invoices[1], unit_price: 2000, quantity: 2)
      inv_items_2 = create_list(:invoice_item, 3, invoice: invoices[2], unit_price: 3000, quantity: 3)
      
      expect(invoices[0].total_invoice_revenue_dollars).to eq(30.00)
      expect(invoices[1].total_invoice_revenue_dollars).to eq(120.00)
      expect(invoices[2].total_invoice_revenue_dollars).to eq(270.00)
    end

    describe '#discounted_revenue' do
      before :each do
        @merchant = create(:merchant)


        @bulk_discount_1 = create(:bulk_discount, threshold: 2, discount: 20,merchant: @merchant)
        @bulk_discount_2 = create(:bulk_discount, threshold: 4, discount: 40,merchant: @merchant)
        @bulk_discount_3 = create(:bulk_discount, threshold: 6, discount: 40,merchant: @merchant)
        @bulk_discount_4 = create(:bulk_discount, threshold: 8, discount: 50,merchant: @merchant)



        
        @items = create_list(:item, 3, merchant: @merchant)
        #@items[0] - no discounts
        #@items[1] - 40
        #@items[2] - 50

        @inv = create(:invoice)

        #merchant has 2 items that qualify for discounts on this invoice
        @inv_item_1 = create(:invoice_item, invoice: @inv, item: @items[0], unit_price: 5, quantity: 1)
        @inv_item_2 = create(:invoice_item, invoice: @inv, item: @items[1], unit_price: 3, quantity: 5)
        @inv_item_3 = create(:invoice_item, invoice: @inv, item: @items[2], unit_price: 2, quantity: 9) 

           #total revenue = 5 + 15 + 18 = 38
           #total discount revenue = 5 + 9 (15*.6) + 9(18*.5) = 23
           #total discount = 15 (38-23)
      end

      describe 'finds the best discount if a bulk discount applies to an invoice_item for all invoice_items' do
        it 'only shows invoice_items where a discount is applicable' do
          expect(@inv.merchant_discounted_invoice_items(@merchant.id).pluck(:id)).to eq([@inv_item_2.id, @inv_item_3.id])
          expect(@inv.merchant_discounted_invoice_items(@merchant.id).pluck(:id)).to_not include(@inv_item_1.id)
        end

        it 'only shows invoice_items for a specific merchant' do
          other_merchant = create(:merchant)
          items_2 = create_list(:item, 2, merchant: other_merchant)
          #other merchant has 1 item that qualifies for discounts
          inv_item_4 = create(:invoice_item, invoice: @inv, item: items_2[0], unit_price: 1, quantity: 9)
          inv_item_5 = create(:invoice_item, invoice: @inv, item: items_2[1], unit_price: 4, quantity: 9)
          bulk_discount_5 = create(:bulk_discount, threshold: 3, discount: 50,merchant: other_merchant)
          bulk_discount_6 = create(:bulk_discount, threshold: 4, discount: 80,merchant: other_merchant)
          expect(@inv.merchant_discounted_invoice_items(@merchant.id).pluck(:id)).to_not include(inv_item_4.id)
          expect(@inv.merchant_discounted_invoice_items(@merchant.id).pluck(:id)).to_not include(inv_item_5.id)
        end


        it 'only shows invoice_items for a specific invoice' do
          other_inv = create(:invoice)
          inv_item_6 = create(:invoice_item, invoice: other_inv, item: @items[0], unit_price: 5, quantity: 1)
          inv_item_7 = create(:invoice_item, invoice: other_inv, item: @items[1], unit_price: 3, quantity: 5)
          expect(@inv.merchant_discounted_invoice_items(@merchant.id).pluck(:id)).to_not include(inv_item_6.id)
          expect(@inv.merchant_discounted_invoice_items(@merchant.id).pluck(:id)).to_not include(inv_item_7.id)
        end

        it 'displays the best discount (in decimals) for every invoice_item' do
          expect(@inv.merchant_discounted_invoice_items(@merchant.id).find_by(item_id: @items[2]).discount).to eq(0.5)
          @bulk_discount_5 = create(:bulk_discount, threshold: 8, discount: 80,merchant: @merchant)
          expect(@inv.merchant_discounted_invoice_items(@merchant).find_by(item_id: @items[2]).discount).to eq(0.8)
        end
      end

      describe 'final discount' do
        it 'sums the discount for all a merchants eligible items on an invoice' do
          expect(@inv.merchant_final_discount(@merchant)).to eq(15)
        end

        it 'only sums the discounts from a single merchant' do
          other_merchant = create(:merchant)
          items_2 = create_list(:item, 2, merchant: other_merchant)
          #other merchant has 1 item that qualifies for discounts
          inv_item_4 = create(:invoice_item, invoice: @inv, item: items_2[0], unit_price: 1, quantity: 9)
          inv_item_5 = create(:invoice_item, invoice: @inv, item: items_2[1], unit_price: 4, quantity: 9)
          bulk_discount_5 = create(:bulk_discount, threshold: 3, discount: 50,merchant: other_merchant)
          bulk_discount_6 = create(:bulk_discount, threshold: 4, discount: 80,merchant: other_merchant)
          expect(@inv.merchant_final_discount(@merchant)).to eq(15)
        end
      end

      describe '#merchant_total_invoice_revenue' do
        it 'subtracts a merchants discounts from the total of an invoice for that merchant' do
          expect(@inv.merchant_total_invoice_revenue(@merchant)).to eq(38)
        end

        it 'only sums the total from a single merchant' do
          other_merchant = create(:merchant)
          items_2 = create_list(:item, 2, merchant: other_merchant)
          #other merchant has 1 item that qualifies for discounts
          inv_item_4 = create(:invoice_item, invoice: @inv, item: items_2[0], unit_price: 1, quantity: 9)
          inv_item_5 = create(:invoice_item, invoice: @inv, item: items_2[1], unit_price: 4, quantity: 9)
          bulk_discount_5 = create(:bulk_discount, threshold: 3, discount: 50,merchant: other_merchant)
          bulk_discount_6 = create(:bulk_discount, threshold: 4, discount: 80,merchant: other_merchant)
          expect(@inv.merchant_total_invoice_revenue(@merchant)).to eq(38)
        end

      end

      describe '#merchant_total_discounted_revenue' do
        it 'subtracts a merchants discounts from the total of an invoice for that merchant' do
          expect(@inv.merchant_total_discounted_revenue(@merchant)).to eq(23)
        end
      end

      describe '#any_merchant_discounts?' do
        it 'returns false if no discounts apply to the current invoice' do
          no_disco_invoice = create(:invoice)
          other_merchant = create(:merchant)
          items_2 = create_list(:item, 2, merchant: other_merchant)
          #other merchant has 1 item that qualifies for discounts
          inv_item_4 = create(:invoice_item, invoice: no_disco_invoice, item: items_2[0], unit_price: 1, quantity: 9)
          inv_item_5 = create(:invoice_item, invoice: no_disco_invoice, item: items_2[1], unit_price: 4, quantity: 9)
          bulk_discount_5 = create(:bulk_discount, threshold: 50, discount: 50,merchant: other_merchant)
          bulk_discount_6 = create(:bulk_discount, threshold: 200, discount: 80,merchant: other_merchant)
          expect(no_disco_invoice.any_merchant_discounts?(other_merchant)).to eq(false)
        end

        it 'returns true if discounts apply to the current invoice' do
          expect(@inv.any_merchant_discounts?(@merchant)).to eq(true)
        end
      end
    end
  end
end
