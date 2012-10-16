class HyundaiCardUsedHistoriesController < ApplicationController
  def index
    collection = unless params[:creditcard_id].blank?
              Creditcard.find(params[:creditcard_id]).hyundai_card_used_histories
             else
              HyundaiCardUsedHistory.scoped
             end

    @used_histories = collection.page(params[:page])
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

  def preview
    @used_histories = HyundaiCardUsedHistory.preview_stylesheet(params[:upload])
  rescue => error
    redirect_to [:excel, :hyundai_card_used_histories], alert: error.message
  end

  def upload
    HyundaiCardUsedHistory.create_with_stylesheet(params[:upload])
    redirect_to :hyundai_card_used_histories
  end

  def destroy
    @used_history = HyundaiCardUsedHistory.find(params[:id])
    @used_history.destroy
    redirect_to :hyundai_card_used_histories
  end
end