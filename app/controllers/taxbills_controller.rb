class TaxbillsController < ApplicationController
  expose(:taxbills) { Taxbill.search(params).latest.page(params[:page]) }
  expose(:taxbill)

  def total
    @purchases = taxbills.purchases
    @sales = taxbills.sales
    @cards = CardUsedSource.where("")
  end

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

  private
    def current_year
      params[:at] = Time.zone.now.year unless params[:at]
      Time.zone.parse("#{params[:at]}-01-01 00:00:00")
    end
    helper_method :current_year

    def oldest_year
      purchase = @purchases.oldest_at
      sales = @sales.oldest_at
      card = @cards.oldest_at

      [purchase, sales, card].min.year
    end
    helper_method :oldest_year
end