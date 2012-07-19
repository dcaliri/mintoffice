class CardUsedSourcesController < ApplicationController
  expose(:creditcard) { Creditcard.find(params[:creditcard_id]) unless params[:creditcard_id].blank? }
  expose(:card_used_source)

  def index
    used_sources = creditcard.nil? ? CardUsedSource : creditcard.card_used_sources
    @card_used_sources = used_sources.latest.search(params[:query]).page(params[:page])
  end

  def create
    card_used_source = creditcard.card_used_sources.build(params[:card_used_source])
    if card_used_source.save
      redirect_to card_used_source
    else
      redirect_to new_card_used_source_path, notice: t('controllers.card_used_sources.check')
    end
  end

  def update
    card_used_source.creditcard = creditcard
    if card_used_source.save
      redirect_to card_used_source
    else
      redirect_to card_used_source, notice: t('controllers.card_used_sources.check')
    end
  end

  def export
    used_sources = creditcard.nil? ? CardUsedSource : creditcard.card_used_sources
    include_column = current_user.except_columns.default_columns_by_key('CardUsedSource')

    send_file used_sources.latest.search(params[:query]).export(params[:to].to_sym, include_column)
  end

  def destroy
    card_used_source.destroy
    redirect_to :card_used_sources
  end
end