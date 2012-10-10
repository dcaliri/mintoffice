# encoding: UTF-8

module PaymentRequestHelper
  def options_for_payment_request_select
    collection = [["전체", :all], ["청구전", :not_created], ["청구후 지급전", :not_complete], ["지급 완료", :complete]]
    options_for_select(collection,  params[:request_status])
  end
end