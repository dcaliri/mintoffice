class TaxbillsController < ApplicationController
  def index
    @taxbills = Taxbill.page(params[:page])
  end

  def show
    @taxbill = Taxbill.find(params[:id])
  end

  def new
    @taxbill = Taxbill.new
  end

  def create
    @taxbill = Taxbill.new(params[:taxbill])
    @taxbill.save!
    redirect_to @taxbill, notice: I18n.t("common.messages.created", :model => Taxbill.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def edit
    @taxbill = Taxbill.find(params[:id])
  end

  def update
    @taxbill = Taxbill.find(params[:id])
    @taxbill.update_attributes(params[:taxbill])
    redirect_to @taxbill, notice: I18n.t("common.messages.updated", :model => Taxbill.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @taxbill = Taxbill.find(params[:id])
    @taxbill.destroy
    redirect_to :taxbills, notice: I18n.t("common.messages.destroyed", :model => Taxbill.model_name.human)
  end
end