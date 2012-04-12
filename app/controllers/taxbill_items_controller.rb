class TaxbillItemsController < ApplicationController
  expose(:taxbill)
  expose(:taxbill_items) { taxbill.items }
  expose(:taxbill_item)

  def create
    taxbill_item.save!
    redirect_to taxbill
  end

  def update
    taxbill_item.save!
    redirect_to taxbill
  end

  def destroy
    taxbill_item.destroy
    redirect_to taxbill
  end
end