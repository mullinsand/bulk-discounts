class Invoice < ApplicationRecord
  enum status: ["In Progress", "Completed", "Cancelled"]

  validates_presence_of :status, inclusion: ["In Progress", "Completed", "Cancelled"]
  validates_presence_of :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :bulk_discounts, through: :invoice_items



  def find_invoice_item_quantity(invoice, item)
    InvoiceItem.find_by(invoice: invoice, item: item).quantity
  end

  def find_invoice_item_status(invoice, item)
    InvoiceItem.find_by(invoice: invoice, item: item).status
  end

  def total_revenue
    items.
    joins(:invoice_items).
    sum('invoice_items.quantity * invoice_items.unit_price')
  end

  def self.incomplete_invoices_sorted
     joins(:invoice_items)
    .distinct
    .where.not("invoice_items.status = ?", 2)
    .order(:created_at)
  end

  def total_invoice_revenue
    items
    .joins(:invoice_items)
    .sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def total_invoice_revenue_dollars 
    total_invoice_revenue.to_f / 100
  end

  def merchant_total_invoice_revenue(merchant_id)
    items
    .joins(:invoice_items)
    .where('items.merchant_id = ?', merchant_id)
    .sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def merchant_discounted_invoice_items(merchant_id)
    invoice_items.select('invoice_items.*, invoice_items.quantity * invoice_items.unit_price as revenue, max(bulk_discounts.discount)/100.0 as discount')
    .joins(:bulk_discounts)
    .where("invoice_items.quantity >= bulk_discounts.threshold and items.merchant_id = ?", merchant_id)
    .group(:id)
  end

  def merchant_final_discount(merchant_id)
    Invoice
    .select('sum(subquery.revenue * subquery.discount) as total_discount')
    .from(self.merchant_discounted_invoice_items(merchant_id))[0].total_discount
  end

  def merchant_total_discounted_revenue(merchant_id)
    merchant_total_invoice_revenue(merchant_id) - merchant_final_discount(merchant_id)
  end

  def any_merchant_discounts?(merchant_id)
    return false if merchant_id.bulk_discounts.empty?
    !merchant_discounted_invoice_items(merchant_id).empty?
  end
end