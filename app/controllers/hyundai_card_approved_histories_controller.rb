class HyundaiCardApprovedHistoriesController < ApplicationController
  def index
    collection = unless params[:creditcard_id].blank?
                   Creditcard.find(params[:creditcard_id]).hyundai_card_approved_histories
                 else
                   HyundaiCardApprovedHistory.scoped
                 end

    @approved_histories = collection.page(params[:page])
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

  def preview
    @approved_histories = HyundaiCardApprovedHistory.preview_stylesheet(params[:upload])
  rescue => error
    redirect_to [:excel, :hyundai_card_approved_histories], alert: error.message
  end

  def upload
    HyundaiCardApprovedHistory.create_with_stylesheet(params[:upload])
    redirect_to :hyundai_card_approved_histories
  end

  def destroy
    @approved_history = HyundaiCardApprovedHistory.find(params[:id])
    @approved_history.destroy
    redirect_to :hyundai_card_approved_histories
  end
end