class PaymentRequestsController < ApplicationController
  def index
    @payment_requests = PaymentRequest.scoped
  end

  def show
    @payment_request = PaymentRequest.find(params[:id])
  end

  def new
    @payment_request = PaymentRequest.new
  end

  def create
    @payment_request = PaymentRequest.new(params[:payment_request])
    @payment_request.save!
    redirect_to @payment_request
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def edit
    @payment_request = PaymentRequest.find(params[:id])
  end

  def update
    @payment_request = PaymentRequest.find(params[:id])
    @payment_request.update_attributes!(params[:payment_request])
    redirect_to @payment_request
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @payment_request = PaymentRequest.find(params[:id])
    @payment_request.destroy
    redirect_to :payment_requests
  end
end