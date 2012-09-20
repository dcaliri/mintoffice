class CreditcardsController < ApplicationController
  before_filter :only => [:show] do |c|
    @creditcard = Creditcard.find(params[:id])
    c.save_attachment_id @creditcard
  end

  def index
    @creditcards = Creditcard.all
  end

  def show
    @creditcard = Creditcard.find(params[:id])
  end

  def new
    @creditcard = Creditcard.new
  end

  def edit
    @creditcard = Creditcard.find(params[:id])
  end

  def create
    @creditcard = Creditcard.new(params[:creditcard])
    @creditcard.save!
    redirect_to @creditcard, notice: t("common.messages.created", :model => Creditcard.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def update
    @creditcard = Creditcard.find(params[:id])
    @creditcard.update_attributes!(params[:creditcard])
    redirect_to @creditcard, notice: t("common.messages.updated", :model => Creditcard.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @creditcard = Creditcard.find(params[:id])
    @creditcard.destroy

    redirect_to :creditcards
  end
end
