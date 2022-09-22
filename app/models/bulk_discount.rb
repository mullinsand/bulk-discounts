class BulkDiscount < ApplicationRecord
  validates_presence_of :discount
  validates_presence_of :threshold
  validates_presence_of :merchant_id

  belongs_to :merchant

end