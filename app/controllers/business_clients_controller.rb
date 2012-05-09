class BusinessClientsController < ApplicationController
  before_filter :only => [:show] do |c|
    @business_client = BusinessClient.find(params[:id])
    c.save_attachment_id @business_client
  end

  def index
    @business_clients = BusinessClient.search(params[:query]).page(params[:page])
  end

  def new
    @business_client = BusinessClient.new
  end

  def show
    @business_client = BusinessClient.find(params[:id])
  end

  def create
    @business_client = BusinessClient.new(params[:business_client])
    @business_client.save!
    redirect_to @business_client, notice: I18n.t("common.messages.created", :model => BusinessClient.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def edit
    @business_client = BusinessClient.find(params[:id])
  end

  def update
    @business_client = BusinessClient.find(params[:id])
    @business_client.update_attributes!(params[:business_client])
    redirect_to @business_client, notice: I18n.t("common.messages.updated", :model => BusinessClient.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @business_client = BusinessClient.find(params[:id])
    @business_client.destroy
    redirect_to :business_clients, notice: I18n.t("common.messages.destroyed", :model => BusinessClient.model_name.human)
  end
end