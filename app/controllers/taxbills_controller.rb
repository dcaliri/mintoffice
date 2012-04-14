class TaxbillsController < ApplicationController
  expose(:taxbill_with_pagination) { Taxbill.search(params[:query]).page(params[:page]) }
  expose(:taxbills)
  expose(:taxbill)

  def show
    @attachments = Attachment.for_me(taxbill)
    session[:attachments] = [] if session[:attachments].nil?
    @attachments.each { |at| session[:attachments] << at.id }
  end

  def create
    taxbill.save!
      Attachment.save_for(taxbill, @user, params[:attachment])
    redirect_to taxbill, notice: I18n.t("common.messages.created", :model => Taxbill.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def edit
    @attachments = Attachment.for_me(taxbill)
  end

  def update
    taxbill.save!
    Attachment.save_for(taxbill, @user, params[:attachment])
    redirect_to taxbill, notice: I18n.t("common.messages.updated", :model => Taxbill.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    taxbill.destroy
    redirect_to :taxbills, notice: I18n.t("common.messages.destroyed", :model => Taxbill.model_name.human)
  end
end