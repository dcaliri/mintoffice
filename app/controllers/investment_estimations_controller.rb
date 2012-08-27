class InvestmentEstimationsController < ApplicationController
  before_filter :find_investment

  def new
    @estimation = @investment.estimations.build
  end

  def create
    @estimation = @investment.estimations.build(params[:investment_estimation])
    @estimation.save!
    redirect_to @investment
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def edit
    @estimation = @investment.estimations.find(params[:id])
  end

  def update
    @estimation = @investment.estimations.find(params[:id])
    @estimation.update_attributes!(params[:investment_estimation])
    redirect_to @investment
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @estimation = @investment.estimations.find(params[:id])
    @estimation.destroy
    redirect_to @investment
  end

private
  def find_investment
    @investment = Investment.find(params[:investment_id])
  end
end