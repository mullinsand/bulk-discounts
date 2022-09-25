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
    redirect_to admin_invoice_path(params[:id])

    if @invoice.status == "Completed" && @invoice.any_discounts?
      @invoice.invoice_items.each do |item|
        
      end
    end
  end

private
  
  def invoice_params
    params.permit(:status)
  end


end