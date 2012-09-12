class HyundaiCardApprovedHistoriesController < ApplicationController
    def index
    @approved_histories = HyundaiCardApprovedHistory.scoped
  end

  def show
    @approved_history = HyundaiCardApprovedHistory.find(params[:id])
  end

  def new
    @approved_history = HyundaiCardApprovedHistory.new
  end

  def create
    @approved_history = HyundaiCardApprovedHistory.new(params[:hyundai_card_approved_history])
    @approved_history.save!
    redirect_to @approved_history
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def edit
    @approved_history = HyundaiCardApprovedHistory.find(params[:id])
  end

  def update
    @approved_history = HyundaiCardApprovedHistory.find(params[:id])
    @approved_history.update_attributes!(params[:hyundai_card_approved_history])
    redirect_to @approved_history
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @approved_history = HyundaiCardApprovedHistory.find(params[:id])
    @approved_history.destroy
    redirect_to :hyundai_card_approved_histories
  end
end