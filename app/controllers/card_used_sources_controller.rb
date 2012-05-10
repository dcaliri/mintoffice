class CardUsedSourcesController < ApplicationController
  def index
    unless params[:creditcard_id].blank?
      @card_used_sources = Creditcard.find(params[:creditcard_id]).card_used_sources
    else
      @card_used_sources = CardUsedSource
    end
    @card_used_sources = @card_used_sources.latest.page(params[:page])
  end

  def show
    @card_used_source = CardUsedSource.find(params[:id])
  end

  def preview
    @card_used_sources = CardUsedSource.preview_stylesheet(creditcard, params[:upload])
  end

  def upload
    @card_used_sources.create_with_stylesheet(creditcard, params[:upload])
    redirect_to :card_used_sources
  end

  def new
    @card_used_source = CardUsedSource.new
  end

  def create
    @card_used_source = CardUsedSource.new(params[:card_used_source])
    @card_used_source.save!
    redirect_to @card_used_source
  end

  def edit
    @card_used_source = CardUsedSource.find(params[:id])
  end

  def update
    @card_used_source = CardUsedSource.find(params[:id])
    @card_used_source.save!
    redirect_to @card_used_source
  end

  def destroy
    @card_used_source = CardUsedSource.find(params[:id])
    @card_used_source.destroy
    redirect_to :card_used_sources
  end
end