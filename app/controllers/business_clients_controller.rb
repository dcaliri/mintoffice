class BusinessClientsController < ApplicationController
  def index
    @business_clients = BusinessClient.page(params[:page])
  end

  def new
    @business_client = BusinessClient.new
  end

  def show
    @business_client = BusinessClient.find(params[:id])
    @attachments = Attachment.for_me(@business_client)
    session[:attachments] = [] if session[:attachments].nil?
    @attachments.each { |at| session[:attachments] << at.id }
  end

  def create
    @business_client = BusinessClient.new(params[:business_client])
    @business_client.save!
    Attachment.save_for(@business_client, @user, params[:attachment])
    redirect_to @business_client
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def edit
    @business_client = BusinessClient.find(params[:id])
    @attachments = Attachment.for_me(@business_client)
  end

  def update
    @business_client = BusinessClient.find(params[:id])
    @business_client.update_attributes!(params[:business_client])
    Attachment.save_for(@business_client, @user, params[:attachment])
    redirect_to @business_client
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @business_client = BusinessClient.find(params[:id])
    @business_client.destroy
    redirect_to :business_clients
  end
end