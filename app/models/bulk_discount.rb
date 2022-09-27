class BulkDiscount < ApplicationRecord
  validates :discount, presence: true,
    numericality: { greater_than: 0, less_than_or_equal_to: 100}
  validates_presence_of :threshold
  validates_presence_of :merchant_id
  validates :name, presence: true
  validates :discount_type, presence: true
  validate :applicable_discount?

  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items

  # before_update :has_pending_invoices?
  before_destroy :has_pending_invoices?

  def find_pending_invoices
    return [] if invoices.empty?
    invoices
    .where("invoices.status = 0 and invoice_items.quantity >= ?", self.threshold)
  end

  def self.find_holiday_discount(holiday)
    find_by(discount_type: holiday)
  end

  def find_better_discount
    BulkDiscount
    .where("discount >= ? and threshold <= ? and merchant_id = ? and discount_type = 'normal'", self.discount, self.threshold, self.merchant_id)
    .where.not(id: self)
  end

  def has_pending_invoices?
    unless self.find_pending_invoices.empty?
      self.errors.add(:base, "Cannot modify or delete discount #{self.id} because it has been applied to a pending invoice")
      return false
    end
    true
  end
  private
  
  def applicable_discount?
    unless self.find_better_discount.empty?
      #holiday discount exception
      self.errors.add(:base, "This discount is superfluous and will not be added, be more generous")
      return false
    end
  end

end