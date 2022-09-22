class BulkDiscountsController < ApplicationController
  def index
    @bulk_discounts = Merchant.find(params[:merchant_id]).bulk_discounts
  end

  def show

  end

  def new
    @bulk_discount = BulkDiscount.new
  end

  # def create
  #   merchant = Merchant.find(params[:merchant_id])
  #   item = merchant.items.new(model_item_params)
  #   if item.save
  #     redirect_to merchant_items_path(params[:merchant_id])
  #   else
  #     redirect_to new_merchant_item_path(params[:merchant_id])
  #     flash[:alert] = "Error: #{error_message(item.errors)}"
  #   end
  # end

  # def edit
  #   @item = Item.find(params[:id])
  #   @merchant = Merchant.find(params[:merchant_id])
  # end

  # def update
  #   @item = Item.find(params[:id])

  #   if params[:status].present?
  #     @item.update(item_params)
  #     redirect_to merchant_items_path(params[:merchant_id])
  #   elsif @item.update(item_params)
  #     redirect_to merchant_item_path(params[:merchant_id], params[:id])
  #     flash[:notice] = 'Item edited successfully!'
  #   else
  #     redirect_to edit_merchant_item_path(params[:merchant_id], params[:id])
  #     flash[:alert] = "Error: #{@item.errors.full_messages.to_sentence}"
  #   end

  # end

  # private
  # def model_item_params
  #   params.require(:item).permit(:name, :description, :unit_price)
  # end

  # def item_params
  #     if params[:status] == "0"
  #       params[:status] = 0
  #     elsif params[:status] == "1"
  #       params[:status] = 1
  #     end
  #   params.permit(:name, :description, :unit_price, :status)
  # end
end
