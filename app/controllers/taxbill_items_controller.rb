class TaxbillItemsController < ApplicationController
  before_filter :find_taxbill

  def new
    @item = @taxbill.items.new
  end

  private
  def find_taxbill
    @taxbill = Taxbill.find(params[:taxbill_id])
  end
end