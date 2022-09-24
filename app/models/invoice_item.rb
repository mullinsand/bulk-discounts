class InvoiceItem < ApplicationRecord
  enum status: ["Pending", "Packaged", "Shipped"]

  validates_presence_of :item_id
  validates_presence_of :invoice_id
  validates :quantity, presence: :true, numericality: { only_integer: true }
  validates :unit_price, presence: :true, numericality: { only_integer: true }
  validates_presence_of :status, inclusion: ["Pending", "Packaged", "Shipped"]

  belongs_to :item
  belongs_to :invoice
  has_many :bulk_discounts, through: :item

  def self.unshipped_invoice_items
    where.not(status: 2)
  end

  # def self.total_discount(merchant_id, invoice_id)
  #   find_by_sql("SELECT sum(discount_final.bulk_discount) FROM
  #   (SELECT discount_invoice_items.*, discount_invoice_items.revenue * discount_invoice_items.discount as bulk_discount
  #   FROM (SELECT invoice_items.*, invoice_items.quantity * invoice_items.unit_price as revenue, max(bulk_discounts.discount)/100.0 as discount FROM invoice_items 
  #   INNER JOIN items ON items.id = invoice_items.item_id 
  #   INNER JOIN merchants ON merchants.id = 34
  #   INNER JOIN bulk_discounts ON bulk_discounts.merchant_id = merchants.id 
  #   WHERE invoice_items.quantity >= bulk_discounts.threshold
  #   GROUP BY invoice_items.id) as discount_invoice_items
  #   WHERE discount_invoice_items.invoice_id = 312) as discount_final")
  # end

  # def self.discounted_invoice_items(merchant_id, invoice_id)
  #   select('invoice_items.*, invoice_items.quantity * invoice_items.unit_price as revenue, max(bulk_discounts.discount)/100.0 as discount')
  #   .joins(:bulk_discounts)
  #   .where("invoice_items.quantity >= bulk_discounts.threshold and items.merchant_id = ? and invoice_items.invoice_id = ?", merchant_id, invoice_id)
  #   .group(:id)

  # end

  # def final_discount(invoice)
  #   invoice_items.select('sum(subquery.revenue * subquery.discount) as sum')
  #   .from(discount_invoice_items)

  #   discount_final[0].sum
  # end

  # def self.total_discount2(merchant_id, invoice_id)
  #   discount_invoice_items = 
  #   InvoiceItem
  #   .select('invoice_items.*, invoice_items.quantity * invoice_items.unit_price as revenue, max(bulk_discounts.discount)/100.0 as discount')
  #   .joins(:bulk_discounts)
  #   .where("invoice_items.quantity >= bulk_discounts.threshold")
  #   .group(:id)

  #   discount_final =
  #   InvoiceItem
  #   .select('sum(subquery.revenue * subquery.discount) as sum')
  #   .from(discount_invoice_items)
  #   .where('subquery.invoice_id = ? and (subquery.item_id IN
  #     (SELECT items.id FROM items WHERE items.merchant_id = ?))', invoice_id, merchant_id)

  #   discount_final[0].sum
  # end
end