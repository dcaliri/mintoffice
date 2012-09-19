# encoding: UTF-8

class CardHistoriesController < ApplicationController
  include AccessorsHelper
  
  def index
    @card_histories = CardHistory.page(params[:page])
  end

  def show
    @card_history = CardHistory.find(params[:id])
  end

  def new
    @card_history = CardHistory.new
  end

  def create
    card_history = CardHistory.build(params[:card_history])
    card_history.save!
    redirect_to card_history
  end

  def generate
    CardHistory.generate
    redirect_to :back, notice: "성공적으로 카드 사용내역을 생성했습니다."
  end

  def edit
    @card_history = CardHistory.find(params[:id])
  end

  def update
    @card_history = CardHistory.find(params[:id])
    @card_history.update_attributes!(params[:card_history])
    redirect_to @card_history
  end

  def destroy
    @card_history = CardHistory.find(params[:id])
    @card_history.destroy
    redirect_to :CardHistory
  end

  def raw
    redirect_to params[:move_to].to_sym
  end

  def find_empty_cardbill
    @card_histories = CardHistory.find_empty_cardbill.latest.page(params[:page])
  end

  def generate
    owner = find_access_owner(params[:owner])
    total_count = CardHistory.generate_cardbill(owner)
    redirect_to :card_histories, notice: t('card_approved_sources.generate.success', owner: owner.name, amount: total_count)
  end
end