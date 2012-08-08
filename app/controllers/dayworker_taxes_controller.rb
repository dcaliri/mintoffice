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
end