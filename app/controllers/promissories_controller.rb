class PromissoriesController < ApplicationController
  def show
    @promissory = Promissory.find(params[:id])
  end

  def new
    @promissory = Promissory.new
  end

  def create
    @promissory = Promissory.new(params[:promissory])
    @promissory.save!
    redirect_to @promissory
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def edit
    @promissory = Promissory.find(params[:id])
  end

  def update
    @promissory = Promissory.find(params[:id])
    @promissory.update_attributes!(params[:promissory])
    redirect_to @promissory
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @promissory = Promissory.find(params[:id])
    @promissory.destroy
    redirect_to :bank_accounts
  end
end