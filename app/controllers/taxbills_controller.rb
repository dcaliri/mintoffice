class TaxbillsController < ApplicationController
  before_filter :manage_search_option, :only => :index

  expose(:taxbills) { Taxbill.all }
  expose(:taxbills_pagination) { Taxbill.search(params).latest.page(params[:page]) }
  expose(:taxbill)

  def total
    @purchases = Taxbill.purchases
    @sales = Taxbill.sales
    @cards = CardUsedSource
  end

  def show
    session[:attachments] = [] if session[:attachments].nil?
    taxbill.attachments.each { |at| session[:attachments] << at.id }
  end

  def create
    taxbill.save!
    redirect_to taxbill, notice: I18n.t("common.messages.created", :model => Taxbill.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def update
    taxbill.save!
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

    def manage_search_option
      options = [:billtype, :taxman_id]
      options.each do |option|
        option_for_session = "taxbills_#{option}".to_sym
        if params[:clear_session]
          session[option_for_session] = nil
        else
          option_for_params = option

          if params[option_for_params]
            session[option_for_session] = params[option_for_params]
          else
            params[option_for_params] = session[option_for_session]
          end
        end
      end
    end
end