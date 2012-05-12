class CardApprovedSourcesController < ApplicationController
  expose(:creditcard) { Creditcard.find(params[:creditcard_id]) unless params[:creditcard_id].blank? }
  expose(:card_approved_source)

  def index
    approvd_source = creditcard.nil? ? CardApprovedSource : creditcard.card_approved_sources
    @card_approved_sources = approvd_source.latest.page(params[:page])
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
end