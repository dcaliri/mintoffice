class PaymentRecordsController < ApplicationController
  def index
    @payment_records = PaymentRecord.search(params[:query], params[:request_status])
  end

  def show
    @payment_record = PaymentRecord.find(params[:id])
  end

  def new
    @payment_record = PaymentRecord.new
  end

  def create
    @payment_record = PaymentRecord.new(params[:payment_record])
    @payment_record.save!
    redirect_to @payment_record
  end

  def edit
    @payment_record = PaymentRecord.find(params[:id])
  end

  def update
    @payment_record = PaymentRecord.find(params[:id])
    @payment_record.update_attributes!(params[:payment_record])
    redirect_to @payment_record
  end

  def destroy
    @payment_record = PaymentRecord.find(params[:id])
    @payment_record.destroy
    redirect_to :payment_records
  end

  def payment_request
    @payment_record = PaymentRecord.find(params[:id])
    @payment_request = @payment_record.generate_payment_request
    render 'payment_requests/new'
  end

end