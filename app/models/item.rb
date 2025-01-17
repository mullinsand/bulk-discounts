class Item < ApplicationRecord
  enum status: ["Enabled", "Disabled"]
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  validates_presence_of :merchant_id
  validates_presence_of :status, inclusion: ["Enabled", "Disabled"]

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :bulk_discounts, through: :merchant

  scope :by_merchant, ->(merchant_id) { where(merchant_id: merchant_id)}

  def self.successful_transactions
    joins(invoices: :transactions)
    .where(transactions: { result: 0 })
  end

  def self.find_items_to_ship(merchant_id)
    Item.select(:id, :name, "invoices.created_at as invoice_create_date", "invoice_items.invoice_id as invoice_id")
      .joins(:invoices, :invoice_items)
      .distinct
      .where.not("invoice_items.status = ?", 2)
      .where(merchant_id: merchant_id)
      .order("invoice_create_date")
  end
  
  def current_price
    unit_price.to_f / 100
  end

  def best_day
    invoices
    .joins(:transactions)
    .select('invoices.*, count(invoices) as invoice_count')
    .group('invoices.id')
    .where(transactions: {result: 0})
    .order('invoice_count desc')
    .first
    .created_at
  end

  def find_best_discount(invoice_id)
    return nil if self.bulk_discounts.empty?
    bulk_discounts
    .where("? >= bulk_discounts.threshold", self.invoice_items.find_by(invoice_id: invoice_id).quantity)
    .order(discount: :desc)
    .first
  end
end