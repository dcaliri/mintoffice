class TaxbillsController < ApplicationController
  before_filter :manage_search_option, :only => :index
  before_filter :only => [:show] { |c| c.save_attachment_id taxbill.document if taxbill.document }

  before_filter :access_check, except: [:index, :new, :create, :total, :excel, :preview, :import]

  expose(:taxbills) { Taxbill.scoped }
#  expose(:taxbill) { params[:id].nil? ? Taxbill.new : Taxbill.find(params[:id]) }
  expose(:taxbill)

  def total
    @purchases = Taxbill.purchases
    @sales = Taxbill.sales
  end

  def index
    @taxbills = Taxbill.access_list(current_person).search(params).latest.page(params[:page])
  end

  def new
    @document = Document.find(params[:document]) if params[:document]
  end

  def create
    taxbill.document = @document
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

  def preview
    @taxbill_items = Taxbill.preview_stylesheet(params[:billtype], params[:upload])
  end

  def import
    Taxbill.create_with_stylesheet(params[:billtype], params[:upload])
    redirect_to :taxbills
  end

  def payment_request
    @payment_request = taxbill.generate_payment_request
    render 'payment_requests/new'
  end

  private
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