class TaxbillsController < ApplicationController
  expose(:taxbill_with_pagination) { Taxbill.search(params[:query]).page(params[:page]) }
  expose(:taxbills)
  expose(:taxbill)

  def create
    taxbill.save!
    redirect_to taxbill, notice: I18n.t("common.messages.created", :model => Taxbill.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def update
    taxbill.save!
    redirect_to taxbill, notice: I18n.t("common.messages.updated", :model => Taxbill.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    taxbill.destroy
    redirect_to :taxbills, notice: I18n.t("common.messages.destroyed", :model => Taxbill.model_name.human)
  end
end