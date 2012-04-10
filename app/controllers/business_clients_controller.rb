class BusinessClientsController < ApplicationController
  def index
    @business_clients = BusinessClient.page(params[:page])
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
    redirect_to @business_client
  end

  def edit
    @business_client = BusinessClient.find(params[:id])
  end

  def update
    @business_client = BusinessClient.find(params[:id])
    @business_client.update_attributes!(params[:business_client])
    redirect_to @business_client
  end

  def destroy
    @business_client = BusinessClient.find(params[:id])
    @business_client.destroy
    redirect_to :business_clients
  end
end