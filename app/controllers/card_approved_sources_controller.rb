class CardApprovedSourcesController < ApplicationController
  include AccessorsHelper

  expose(:creditcard) { Creditcard.find(params[:creditcard_id]) unless params[:creditcard_id].blank? }
  expose(:card_approved_source)

  def index
    approved_source = creditcard.nil? ? CardApprovedSource : creditcard.card_approved_sources
    @card_approved_sources = approved_source.filter_by_params(params).page(params[:page])
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

  def export
    approved_sources = creditcard.nil? ? CardApprovedSource : creditcard.card_approved_sources
    include_column = current_employee.except_columns.default_columns_by_key('CardApprovedSource')

    send_file approved_sources.filter_by_params(params).export(params[:to].to_sym, include_column)
  end

  def destroy
    card_approved_source.destroy
    redirect_to :card_approved_sources
  end

  def generate_cardbills
    owner = find_access_owner(params[:owner])
    total_count = CardApprovedSource.generate_cardbill(owner)
    redirect_to :card_approved_sources, notice: t('card_approved_sources.generate.success', owner: owner.name, amount: total_count)
  end

  def find_empty_cardbills
    @card_approved_sources = CardApprovedSource.find_empty_cardbill.latest.page(params[:page])
  end
end