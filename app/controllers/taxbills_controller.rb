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
    redirect_to @taxbill
  end
end