class BulkDiscountsController < ApplicationController
  def index
    @bulk_discounts = Merchant.find(params[:merchant_id]).bulk_discounts
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @bulk_discount = BulkDiscount.new
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = merchant.bulk_discounts.new(bulk_discount_params)
    if bulk_discount.save
      redirect_to merchant_bulk_discounts_path(params[:merchant_id])
    else
      redirect_to new_merchant_bulk_discount_path(params[:merchant_id])
      flash[:alert] = "Error: #{error_message(bulk_discount.errors)}"
    end
  end

  def destroy
    BulkDiscount.destroy(params[:id])
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

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

  private
  def bulk_discount_params
    params.require(:bulk_discount).permit(:discount, :threshold)
  end
end
