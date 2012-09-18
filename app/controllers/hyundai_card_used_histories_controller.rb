class HyundaiCardUsedHistoriesController < ApplicationController
  def index
    @used_histories = HyundaiCardUsedHistory.scoped
  end

  def show
    @used_history = HyundaiCardUsedHistory.find(params[:id])
  end

  def new
    @used_history = HyundaiCardUsedHistory.new
  end

  def create
    @used_history = HyundaiCardUsedHistory.new(params[:hyundai_card_used_history])
    @used_history.save!
    redirect_to @used_history
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def edit
    @used_history = HyundaiCardUsedHistory.find(params[:id])
  end

  def update
    @used_history = HyundaiCardUsedHistory.find(params[:id])
    @used_history.update_attributes!(params[:hyundai_card_used_history])
    redirect_to @used_history
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @used_history = HyundaiCardUsedHistory.find(params[:id])
    @used_history.destroy
    redirect_to :hyundai_card_used_histories
  end
end