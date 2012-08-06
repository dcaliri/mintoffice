class PettycashesController < ApplicationController
  before_filter :only => [:show] do |c|
    @pettycash = Pettycash.find(params[:id])
    c.save_attachment_id @pettycash
  end

  def index
    @pettycashes = Pettycash.search(params[:query]).page(params[:page])
    @balance = Pettycash.sum(:inmoney) - Pettycash.sum(:outmoney)
  end

  def show
    @pettycash = Pettycash.find(params[:id])
  end

  def new
    @pettycash = Pettycash.new
  end

  def edit
    @pettycash = Pettycash.find(params[:id])
  end

  def create
    @pettycash = Pettycash.new(params[:pettycash])
    @pettycash.save!
    redirect_to @pettycash, notice: I18n.t("common.messages.created", :model => Pettycash.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def update
    @pettycash = Pettycash.find(params[:id])
    @pettycash.update_attributes!(params[:pettycash])
    redirect_to @pettycash, notice: I18n.t("common.messages.updated", :model => Pettycash.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @pettycash = Pettycash.find(params[:id])
    @pettycash.destroy
    redirect_to(pettycashes_url)
  end
end
