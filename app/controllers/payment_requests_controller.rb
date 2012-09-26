# encoding: UTF-8

class PaymentRequestsController < ApplicationController
  before_filter :set_complete_params, only: [:index, :export]

  def index
    @payment_requests = PaymentRequest.complete(params[:complete]).page(params[:page])
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

  def export
    @payment_requests = PaymentRequest.complete(params[:complete])
    send_file @payment_requests.export(:xls)
  end

  def complete
    @payment_request = PaymentRequest.find(params[:id])
    @payment_request.complete!
    redirect_to @payment_request, notice: "지급을 완료하였습니다."
  end

  def complete_all
    PaymentRequest.complete!
    redirect_to :payment_requests, notice: "지급을 완료하였습니다."
  end

  private
  def set_complete_params
    params[:complete] ||= false
    params[:complete] = (params[:complete] == 'true')
  end
end