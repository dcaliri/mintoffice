# encoding: UTF-8

class CardHistoriesController < ApplicationController
  def index
    @card_histories = card_histories.page(params[:page])
  end

  def show
    @card_history = card_histories.find(params[:id])
  end

  def new
    @card_history = card_histories.new
  end

  def create
    card_history = card_histories.build(params[:card_history])
    card_history.save!
    redirect_to card_history
  end

  def generate
    card_histories.generate
    redirect_to :back, notice: "성공적으로 카드 사용내역을 생성했습니다."
  end

  def edit
    @card_history = card_histories.find(params[:id])
  end

  def update
    @card_history = card_histories.find(params[:id])
    # @card_history.creditcard = find_creditcard
    @card_history.update_attributes!(params[:card_history])
    redirect_to @card_history
  end

  def destroy
    @card_history = card_histories.find(params[:id])
    @card_history.destroy
    redirect_to :card_histories
  end

private
  def card_histories
    creditcard = find_creditcard
    if creditcard
      creditcard.card_approved_sources
    else
      CardHistory.scoped
    end
  end

  def find_creditcard
    unless params[:creditcard_id].blank?
      Creditcard.find(params[:creditcard_id]).card_histories
    end
  end
end