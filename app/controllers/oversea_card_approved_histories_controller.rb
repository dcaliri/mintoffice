class OverseaCardApprovedHistoriesController < ApplicationController
  def index
    collection = unless params[:creditcard_id].blank?
             Creditcard.find(params[:creditcard_id]).oversea_card_approved_histories
           else
             OverseaCardApprovedHistory.scoped
           end

    @approved_histories = collection.page(params[:page])
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

  def preview
    @approved_histories = OverseaCardApprovedHistory.preview_stylesheet(params[:upload])
  rescue => error
    redirect_to [:excel, :oversea_card_approved_histories], alert: error.message
  end

  def upload
    OverseaCardApprovedHistory.create_with_stylesheet(params[:upload])
    redirect_to :oversea_card_approved_histories
  end

  def destroy
    @approved_history = OverseaCardApprovedHistory.find(params[:id])
    @approved_history.destroy
    redirect_to :oversea_card_approved_histories
  end
end