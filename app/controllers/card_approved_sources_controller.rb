class CardApprovedSourcesController < ApplicationController
  expose(:creditcard) { Creditcard.find(params[:creditcard_id]) unless params[:creditcard_id].blank? }
  expose(:card_approved_source)

  def index
    approvd_source = creditcard.nil? ? CardApprovedSource : creditcard.card_approved_sources
    @card_approved_sources = approvd_source.latest.search(params[:query]).page(params[:page])
  end

  def create
    card_approved_source = creditcard.card_approved_sources.build(params[:card_approved_source])
    card_approved_source.save!
    redirect_to card_approved_source
  end

  def update
    card_approved_source.creditcard = creditcard
    card_approved_source.save!
    redirect_to card_approved_source
  end

  def destroy
    card_approved_source.destroy
    redirect_to :card_approved_sources
  end

  def generate_cardbills
    CardApprovedSource.generate_cardbill
    redirect_to :card_approved_sources, notice: "Successfully generate cardbills"
  end

  def find_empty_cardbills
    @card_approved_sources = CardApprovedSource.find_empty_cardbill.latest.page(params[:page])
  end
end