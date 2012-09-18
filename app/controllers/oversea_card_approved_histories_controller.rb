class OverseaCardApprovedHistoriesController < ApplicationController
    def index
    @approved_histories = OverseaCardApprovedHistory.scoped
  end

  def show
    @approved_history = OverseaCardApprovedHistory.find(params[:id])
  end

  def new
    @approved_history = OverseaCardApprovedHistory.new
  end

  def create
    @approved_history = OverseaCardApprovedHistory.new(params[:oversea_card_approved_history])
    @approved_history.save!
    redirect_to @approved_history
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def edit
    @approved_history = OverseaCardApprovedHistory.find(params[:id])
  end

  def update
    @approved_history = OverseaCardApprovedHistory.find(params[:id])
    @approved_history.update_attributes!(params[:oversea_card_approved_history])
    redirect_to @approved_history
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @approved_history = OverseaCardApprovedHistory.find(params[:id])
    @approved_history.destroy
    redirect_to :oversea_card_approved_histories
  end
end