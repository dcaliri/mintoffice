class ShinhanCardApprovedHistoriesController < ApplicationController
  def index
    collection = unless params[:creditcard_id].blank?
                  Creditcard.find(params[:creditcard_id]).shinhan_card_approved_histories
                 else
                  ShinhanCardApprovedHistory.scoped
                 end

    @approved_histories = collection.page(params[:page])
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

  def preview
    @approved_histories = ShinhanCardApprovedHistory.preview_stylesheet(params[:upload])
  rescue => error
    redirect_to [:excel, :shinhan_card_approved_histories], alert: error.message
  end

  def upload
    ShinhanCardApprovedHistory.create_with_stylesheet(params[:upload])
    redirect_to :shinhan_card_approved_histories
  end

  def destroy
    @approved_history = ShinhanCardApprovedHistory.find(params[:id])
    @approved_history.destroy
    redirect_to :shinhan_card_approved_histories
  end
end