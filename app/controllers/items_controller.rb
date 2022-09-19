class ItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @item = Item.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.new
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    item = merchant.items.new(model_item_params)
    if item.save
      redirect_to merchant_items_path(params[:merchant_id])
    else
      redirect_to new_merchant_item_path(params[:merchant_id])
      flash[:alert] = "Error: #{error_message(item.errors)}"
    end
  end

  def edit
    @item = Item.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to merchant_item_path(params[:merchant_id], params[:id])
      flash[:notice] = 'Item edited successfully!'
    else
      redirect_to edit_merchant_item_path(params[:merchant_id], params[:id])
      flash[:alert] = "Error: #{@item.errors.full_messages.to_sentence}"
    end
  end

  private
  def model_item_params
    params.require(:item).permit(:name, :description, :unit_price)
  end

  def item_params
    params.permit(:name, :description, :unit_price)
  end
end
