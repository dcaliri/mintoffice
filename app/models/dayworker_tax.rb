class DayworkerTax < ActiveRecord::Base
  belongs_to :dayworker, :class_name => "Dayworker", :foreign_key => "dayworker_id"

  include PaymentRequestable
  include ActiveRecord::Extensions::TextSearch

  class << self
    def search(text, request_status)
      text = "%#{text}%"
      query = <<-QUERY
        dayworkers.juminno LIKE ? OR dayworker_taxes.reason LIKE ? OR #{Contact.search_by_name_query}
      QUERY

      joins(:dayworker => {:person => :contact}).includes(:payment_request)
        .where(query, text, text, text)
        .search_by_request_status(request_status)
    end
  end

  def bankbook
    bankbook = dayworker.bankbook rescue nil
  end

  def generate_payment_request
    PaymentRequest.generate_payment_request(self, bankbook, pay_amount)
  end
end