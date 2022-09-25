class AddAppliedDiscountColumnToInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    add_column :invoice_items, :applied_discount, :integer, default: 0
  end
end
