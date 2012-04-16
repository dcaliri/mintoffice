class TaxbillItemsController < ApplicationController
  expose(:taxbill)
  expose(:taxbill_items) { taxbill.items }
  expose(:taxbill_item)

  def create
    taxbill_item.save!
    redirect_to taxbill, notice: I18n.t("common.messages.created", :model => TaxbillItem.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def update
    taxbill_item.save!
    redirect_to taxbill, notice: I18n.t("common.messages.created", :model => TaxbillItem.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    taxbill_item.destroy
    redirect_to taxbill, notice: I18n.t("common.messages.destroyed", :model => TaxbillItem.model_name.human)
  end
end