class BusinessClientsController < ApplicationController
  def index
    @business_clients = BusinessClient.page(params[:page])
  end

  def show
    @business_client = BusinessClient.find(params[:id])
  end
end