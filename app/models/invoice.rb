class Invoice < ApplicationRecord
  enum status: ["In Progress", "Completed", "Cancelled"]

  validates_presence_of :status, inclusion: ["In Progress", "Completed", "Cancelled"]
  validates_presence_of :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  def find_invoice_item(invoice, item)
    InvoiceItem.where(invoice: invoice, item: item)
  end

  def revenue_order
    items.
    joins(:invoice_items).
    select('items.*, sum(invoice_items.quantity *invoice_items.unit_price) as revenue').
    group('items.id').
    order(revenue: :desc)
  end

  def total_revenue
    revenue_order.collect {|item| item.revenue }.sum
  end
end