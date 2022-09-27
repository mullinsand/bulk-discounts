class BulkDiscount < ApplicationRecord
  validates :discount, presence: true,
    numericality: { greater_than: 0, less_than_or_equal_to: 100}
  validates_presence_of :threshold
  validates_presence_of :merchant_id
  validates :name, presence: true
  validates :discount_type, presence: true

  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items

  def has_pending_invoices
    !invoices.where(status: 0).empty?
  end

  # def useless_discount?
  #   if self.better_discount_already?
  #     # redirect_to new_merchant_bulk_discount_path(params[:merchant_id])
  #     # flash[:alert] = "This discount is superfluous and will not be added, try again"
  #   else
  #     yield 
  #   end
  # end

  def better_discount_already?
    BulkDiscount.where("discount >= ? and threshold <= ? and merchant_id = ?", self.discount, self.threshold, self.merchant_id).empty?
  end

  def self.find_holiday_discount(holiday)
    find_by(discount_type: holiday)
  end
end