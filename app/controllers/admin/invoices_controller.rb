class Admin::InvoicesController < ApplicationController

  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])
    @invoice_items = @invoice.invoice_items
  end

  def update
    @invoice= Invoice.find(params[:id])
    @invoice.update(invoice_params)
    if @invoice.status == "Completed" && @invoice.any_discounts?
      @invoice.invoice_items.each do |invoice_item|
        if invoice_item.item.find_best_discount(@invoice)
          items_applied_discount = invoice_item.item.find_best_discount(@invoice).discount
          invoice_item.update(applied_discount: items_applied_discount)
        end
      end
    end
    redirect_to admin_invoice_path(params[:id])
  end

private
  
  def invoice_params
    params.permit(:status)
  end


end