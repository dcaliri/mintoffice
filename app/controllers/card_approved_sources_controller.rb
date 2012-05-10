class CardApprovedSourcesController < ApplicationController
  before_filter :find_creditcard
  def find_creditcard
    @creditcard = Creditcard.find(params[:creditcard_id]) unless params[:creditcard_id].blank?
  end

  def index
    source = @creditcard.nil? ? CardApprovedSource : @creditcard.card_approved_sources
    @card_approved_sources = source.latest.page(params[:page])
  end

  def show
    @card_approved_source = CardApprovedSource.find(params[:id])
  end

  def preview
    @card_approved_sources = CardApprovedSource.preview_stylesheet(creditcard, params[:upload])
  end

  def upload
    @card_approved_sources.create_with_stylesheet(creditcard, params[:upload])
    redirect_to :card_approved_sources
  end

  def new
    @card_approved_source = CardApprovedSource.new
  end

  def create
    @card_approved_source = @creditcard.card_approved_sources.build(params[:card_approved_source])
    @card_approved_source.save!
    redirect_to @card_approved_source
  end

  def edit
    @card_approved_source = CardApprovedSource.find(params[:id])
  end

  def update
    @card_approved_source = CardApprovedSource.find(params[:id])
    @card_approved_source.save!
    redirect_to @card_approved_source
  end

  def destroy
    @card_approved_source = CardApprovedSource.find(params[:id])
    @card_approved_source.destroy
    redirect_to :card_approved_sources
  end
end