class CardUsedSourcesController < ApplicationController
  expose(:creditcard) { Creditcard.find(params[:creditcard_id]) unless params[:creditcard_id].blank? }
  expose(:card_used_source)

  def index
    approvd_source = creditcard.nil? ? CardUsedSource : creditcard.card_used_sources
    @card_used_sources = approvd_source.latest.search(params[:query]).page(params[:page])
  end

  def create
    card_used_source = creditcard.card_used_sources.build(params[:card_used_source])
    card_used_source.save!
    redirect_to card_used_source
  end

  def update
    card_used_source.creditcard = creditcard
    card_used_source.save!
    redirect_to card_used_source
  end

  def destroy
    card_used_source.destroy
    redirect_to :card_used_sources
  end
end