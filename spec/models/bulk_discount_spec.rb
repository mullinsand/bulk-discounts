require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'validations' do
    it { should validate_presence_of :discount }
    it { should validate_presence_of :threshold }
    it { should validate_numericality_of(:discount).is_greater_than(0).is_less_than_or_equal_to(100) }
    it { should validate_presence_of :name }
    it { should validate_presence_of :discount_type }
  end

  describe 'relationships' do
    it {should belong_to :merchant }
  end

  describe "instance methods" do
    describe "#has_pending_invoices" do
      it 'returns true if the bulk discount applies to an item on a pending invoice' do
        shady_merchant = create(:merchant)
        discount_with_invoice = create(:bulk_discount, threshold: 2, merchant: shady_merchant)
        in_progress_invoice = create(:invoice, status: 0)
        item_with_discount = create(:item, merchant: shady_merchant)
        invoice_item_pending = create(:invoice_item, invoice: in_progress_invoice, item: item_with_discount, quantity: 4)

        expect(discount_with_invoice.has_pending_invoices).to eq(true)
      end

      it 'returns false if the bulk discount applies to an item with a completed or cancelled invoice' do
        shady_merchant = create(:merchant)
        discount_with_invoice = create(:bulk_discount, threshold: 2, merchant: shady_merchant)
        completed_invoice = create(:invoice, status: 1)
        item_with_discount = create(:item, merchant: shady_merchant)
        invoice_item_pending = create(:invoice_item, invoice: completed_invoice, item: item_with_discount, quantity: 4)

        expect(discount_with_invoice.has_pending_invoices).to eq(false)
      end
    end
  end

  describe "class methods" do
    describe "#better_discount_already?" do
      before :each do
        @merch1 = create(:merchant)
        @bulk_discount_1 = create(:bulk_discount, threshold: 4, discount: 40, merchant: @merch1)
        @bulk_discount_2 = create(:bulk_discount, threshold: 7, discount: 60, merchant: @merch1)
        @merch2 = create(:merchant)
        @best_bulk_discount = create(:bulk_discount, threshold: 1, discount: 100, merchant: @merch2)

      end
      it 'only looks for bulk discounts for a single merchant' do
        bulk_discount_3 = BulkDiscount.new(threshold: 5, discount: 41, merchant: @merch1)
        expect(bulk_discount_3.better_discount_already?).to eq(true)
      end
      
      it 'checks for discounts have equal discount% and higher thresholds' do
        bulk_discount_3 = BulkDiscount.new(threshold: 5, discount: 40, merchant: @merch1)
        expect(bulk_discount_3.better_discount_already?).to eq(false)
      end

      it 'checks for discounts have equal discount% and equal thresholds' do
        bulk_discount_3 = BulkDiscount.new(threshold: 4, discount: 40, merchant: @merch1)
        expect(bulk_discount_3.better_discount_already?).to eq(false)
      end

      it 'checks for discounts have lower discount% and equl thresholds' do
        bulk_discount_3 = BulkDiscount.new(threshold: 4, discount: 39, merchant: @merch1)
        expect(bulk_discount_3.better_discount_already?).to eq(false)
      end
  
      context 'if no already made discounts are better' do
        it "returns false" do
          bulk_discount_3 = BulkDiscount.new(threshold: 5, discount: 41, merchant: @merch1)
          expect(bulk_discount_3.better_discount_already?).to eq(true)
        end
      end
    end
    describe "#find_holiday_discount" do
      it 'searches the discount field for the matching holiday related bulk discount' do
        merch1 = create(:merchant)
        bulk_discount_3 = create(:bulk_discount, discount: 5, threshold: 3, merchant: merch1)
        bulk_discount_4 = create(:bulk_discount, discount: 6, threshold: 4, merchant: merch1)
        christmas_discount_1 = create(:bulk_discount, discount: 50, threshold: 5, discount_type: "Christmas", merchant: merch1)
        thanksgiving_discount_2 = create(:bulk_discount, discount: 50, threshold: 5, discount_type: "Thanksgiving", merchant: merch1)
        bulk_discount_5 = create(:bulk_discount)

        expect(merch1.bulk_discounts.find_holiday_discount("Christmas")).to eq(christmas_discount_1)
        expect(merch1.bulk_discounts.find_holiday_discount("Thanksgiving")).to eq(thanksgiving_discount_2)
      end

      context "if no holidays match argument" do
        it 'it returns nil ' do
          merch1 = create(:merchant)
          bulk_discount_3 = create(:bulk_discount, discount: 5, threshold: 3, merchant: merch1)
          bulk_discount_4 = create(:bulk_discount, discount: 6, threshold: 4, merchant: merch1)
          christmas_discount_1 = create(:bulk_discount, discount: 50, threshold: 5, discount_type: "Christmas", merchant: merch1)
          thanksgiving_discount_2 = create(:bulk_discount, discount: 50, threshold: 5, discount_type: "Thanksgiving", merchant: merch1)
          bulk_discount_5 = create(:bulk_discount)
          expect(merch1.bulk_discounts.find_holiday_discount("Halloween")).to eq(nil)
        end
      end
    end
  end
end