class InvestmentsController < ApplicationController
  def show
    @investment = Investment.find(params[:id])
  end

  def new
    @investment = Investment.new
  end

  def create
    @investment = Investment.new(params[:investment])
    @investment.save!
    redirect_to @investment
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def edit
    @investment = Investment.find(params[:id])
  end

  def update
    @investment = Investment.find(params[:id])
    @investment.update_attributes!(params[:investment])
    redirect_to @investment
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @investment = Investment.find(params[:id])
    @investment.destroy
    redirect_to :bank_accounts
  end
end