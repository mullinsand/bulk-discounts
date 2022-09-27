class AddNameAndTypeColumnsToBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    add_column :bulk_discounts, :name, :string, default: "discount"
    add_column :bulk_discounts, :discount_type, :string, default: "normal"
  end
end
