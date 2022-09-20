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
    if params[:status] == "0"
      params[:status] = 0
    elsif params[:status] == "1"
      params[:status] = 1.
    elsif params[:status] == "2"
      params[:status] = 2
    end
    params.permit(:status)
  end

end