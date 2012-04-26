class TaxmenController < ApplicationController
  before_filter :find_business_client

  def create
    @taxman = @business_client.taxmen.build(params[:taxman])
    @taxman.save!
    redirect_to @business_client
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def edit
    @taxman = @business_client.taxmen.find(params[:id])
  end

  def update
    @taxman = @business_client.taxmen.find(params[:id])
    @taxman.update_attributes(params[:taxman])
    redirect_to @business_client
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @taxman = @business_client.taxmen.find(params[:id])
    @taxman.destroy
    redirect_to @business_client
  end

  private
  def find_business_client
    @business_client = BusinessClient.find(params[:business_client_id])
  end
end