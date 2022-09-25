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
  end

private
  
  def invoice_params
    params.permit(:status)
  end

end