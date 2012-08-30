class DayworkerTaxesController < ApplicationController
  expose (:dayworker_taxes) { DayworkerTax.all }
  expose (:dayworker_tax)

  def create
    dayworker_tax.save!
    redirect_to dayworker_tax
  end

  def update
    dayworker_tax.save!
    redirect_to dayworker_tax
  end

  def payment_request
    @payment_request = dayworker_tax.generate_payment_request
    render 'payment_requests/new'
  end
end