class DayworkerTaxesController < ApplicationController
  expose (:dayworker_tax)

  def index
    @dayworker_taxes = DayworkerTax.search(params[:query], params[:request_status])
  end

  def create
    dayworker_tax.save!
    redirect_to dayworker_tax
  end

  def update
    dayworker_tax.save!
    redirect_to dayworker_tax
  end

  def destroy
    dayworker_tax.destroy
    redirect_to :dayworker_taxes
  end

  def payment_request
    @payment_request = dayworker_tax.generate_payment_request
    render 'payment_requests/new'
  end
end