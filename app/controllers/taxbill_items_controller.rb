class TaxbillItemsController < ApplicationController
  before_filter :find_taxbill

  def new
    @item = @taxbill.items.new
  end

  def create
    @item = @taxbill.items.build(params[:taxbill_item])
    @item.save!
    redirect_to @taxbill
  end

  def edit
    @item = @taxbill.items.find(params[:id])
  end

  def update
    @item = @taxbill.items.find(params[:id])
    @item.update_attributes!(params[:taxbill_item])
    redirect_to @taxbill
  end

  def destroy
    @item = @taxbill.items.find(params[:id])
    @item.destroy
    redirect_to @taxbill
  end

  private
  def find_taxbill
    @taxbill = Taxbill.find(params[:taxbill_id])
  end
end