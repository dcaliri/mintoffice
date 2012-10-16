class ShinhanCardUsedHistoriesController < ApplicationController
	def index
    collection = unless params[:creditcard_id].blank?
                  Creditcard.find(params[:creditcard_id]).shinhan_card_used_histories
                 else
                  ShinhanCardUsedHistory.scoped
                 end

    @used_histories = collection.page(params[:page])
  end

  def show
    @used_history = ShinhanCardUsedHistory.find(params[:id])
  end

  def new
    @used_history = ShinhanCardUsedHistory.new
  end

  def create
    @used_history = ShinhanCardUsedHistory.new(params[:shinhan_card_used_history])
    @used_history.save!
    redirect_to @used_history
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def edit
    @used_history = ShinhanCardUsedHistory.find(params[:id])
  end

  def update
    @used_history = ShinhanCardUsedHistory.find(params[:id])
    @used_history.update_attributes!(params[:shinhan_card_used_history])
    redirect_to @used_history
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def preview
    @used_histories = ShinhanCardUsedHistory.preview_stylesheet(params[:upload])
  rescue => error
    redirect_to [:excel, :shinhan_card_used_histories], alert: error.message
  end

  def upload
    ShinhanCardUsedHistory.create_with_stylesheet(params[:upload])
    redirect_to :shinhan_card_used_histories
  end

  def destroy
    @used_history = ShinhanCardUsedHistory.find(params[:id])
    @used_history.destroy
    redirect_to :shinhan_card_used_histories
  end
end