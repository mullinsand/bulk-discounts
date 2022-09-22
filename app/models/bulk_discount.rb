class BulkDiscount < ApplicationRecord
  validates :discount, presence: true,
    numericality: { greater_than: 0, less_than: 100.1}
  validates_presence_of :threshold
  validates_presence_of :merchant_id

  belongs_to :merchant

end