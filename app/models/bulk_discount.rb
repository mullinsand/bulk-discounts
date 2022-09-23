class BulkDiscount < ApplicationRecord
  validates :discount, presence: true,
    numericality: { greater_than: 0, less_than_or_equal_to: 100}
  validates_presence_of :threshold
  validates_presence_of :merchant_id

  belongs_to :merchant

end