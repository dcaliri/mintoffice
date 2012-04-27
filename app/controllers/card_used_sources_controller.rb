class CardUsedSourcesController < ApplicationController
  expose(:creditcard)
  expose(:card_used_sources) { creditcard.card_used_sources.latest.page(params[:page]) }
  expose(:card_used_source)

  def preview
    @card_used_sources = CardUsedSource.preview_stylesheet(creditcard, params[:upload])
  end

  def upload
    card_used_sources.create_with_stylesheet(creditcard, params[:upload])
    redirect_to [creditcard, :card_used_sources]
  end

  def create
    card_used_source.save!
    redirect_to [creditcard, :card_used_sources]
  end

  def update
    card_used_source.save!
    redirect_to [creditcard, :card_used_sources]
  end

  def destroy
    card_used_source.destroy
    redirect_to [creditcard, :card_used_sources]
  end
end