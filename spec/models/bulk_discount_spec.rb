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
end