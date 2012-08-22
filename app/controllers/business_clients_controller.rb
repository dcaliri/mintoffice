class BusinessClientsController < ApplicationController
  expose(:business_clients) { current_company.business_clients }
  expose(:business_client)

  before_filter :only => [:show] {|c| c.save_attachment_id business_client }

  def index
    @business_clients = business_clients.search(params[:query]).page(params[:page])
  end

  def create
    business_client.save!
    redirect_to business_client, notice: I18n.t("common.messages.created", :model => BusinessClient.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def update
    business_client.update_attributes!(params[:business_client])
    redirect_to business_client, notice: I18n.t("common.messages.updated", :model => BusinessClient.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end
end