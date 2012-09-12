class ShinhanCardApprovedHistoriesController < ApplicationController
  def index
    @approved_histories = ShinhanCardApprovedHistory.scoped
  end

  def show
    @approved_history = ShinhanCardApprovedHistory.find(params[:id])
  end

  def new
    @approved_history = ShinhanCardApprovedHistory.new
  end

  def create
    @approved_history = ShinhanCardApprovedHistory.new(params[:shinhan_card_approved_history])
    @approved_history.save!
    redirect_to @approved_history
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def edit
    @approved_history = ShinhanCardApprovedHistory.find(params[:id])
  end

  def update
    @approved_history = ShinhanCardApprovedHistory.find(params[:id])
    @approved_history.update_attributes!(params[:shinhan_card_approved_history])
    redirect_to @approved_history
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @approved_history = ShinhanCardApprovedHistory.find(params[:id])
    @approved_history.destroy
    redirect_to :shinhan_card_approved_histories
  end
end