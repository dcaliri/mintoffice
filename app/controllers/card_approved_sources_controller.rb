class CardApprovedSourcesController < ApplicationController
  expose(:creditcard)
  expose(:card_approved_sources) { creditcard.card_approved_sources.latest.page(params[:page]) }
  expose(:card_approved_source)

  def preview
    @card_approved_sources = CardApprovedSource.preview_stylesheet(creditcard, params[:upload])
  end

  def upload
    card_approved_sources.create_with_stylesheet(creditcard, params[:upload])
    redirect_to [creditcard, :card_approved_sources]
  end

  def create
    card_approved_source.save!
    redirect_to [creditcard, :card_approved_sources]
  end

  def update
    card_approved_source.save!
    redirect_to [creditcard, :card_approved_sources]
  end

  def destroy
    card_approved_source.destroy
    redirect_to [creditcard, :card_approved_sources]
  end
end