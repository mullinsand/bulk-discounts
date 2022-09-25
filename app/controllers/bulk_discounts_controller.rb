class BulkDiscountsController < ApplicationController

  def index
    @bulk_discounts = Merchant.find(params[:merchant_id]).bulk_discounts
    @holidays = HolidayFacade.get_holidays
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
    bulk_discount = BulkDiscount.find(params[:id])
    if bulk_discount.has_pending_invoices
      flash[:alert] = "Cannot delete discount #{bulk_discount.id} because it has been applied to a pending invoice"
    else
      bulk_discount.destroy
    end
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
    if @bulk_discount.has_pending_invoices
      flash[:alert] = "Cannot update discount #{@bulk_discount.id} because it has been applied to a pending invoice"
      redirect_to merchant_bulk_discount_path(params[:merchant_id], params[:id])
    end
  end

  def update
    @bulk_discount = BulkDiscount.find(params[:id])
    if @bulk_discount.update(bulk_discount_params)
      redirect_to merchant_bulk_discount_path(params[:merchant_id], params[:id])
      flash[:notice] = 'Bulk discount edited successfully!'
    else
      redirect_to edit_merchant_bulk_discount_path(params[:merchant_id], params[:id])
      flash[:alert] = "Error: #{@bulk_discount.errors.full_messages.to_sentence}"
    end
  end

  private
  def bulk_discount_params
    params.require(:bulk_discount).permit(:discount, :threshold)
  end

end
