class InvoiceItem < ApplicationRecord
  enum status: ["Pending", "Packaged", "Shipped"]

  validates_presence_of :item_id
  validates_presence_of :invoice_id
  validates :quantity, presence: :true, numericality: { only_integer: true }
  validates :unit_price, presence: :true, numericality: { only_integer: true }
  validates_presence_of :status, inclusion: ["Pending", "Packaged", "Shipped"]
  validates :applied_discount, presence: true,
  numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100}

  belongs_to :item
  belongs_to :invoice
  has_many :bulk_discounts, through: :item

  def self.unshipped_invoice_items
    where.not(status: 2)
  end

end