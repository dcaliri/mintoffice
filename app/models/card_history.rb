class CardHistory < ActiveRecord::Base
  belongs_to :creditcard

  class << self
    def generate
      transaction do
        CardUsedSource.find_each do |used_source|
          approved_source = CardApprovedSource.find_by_approve_no(used_source.approve_no)

          if used_source and approved_source
            history = CardHistory.find_by_approved_number(used_source.approve_no)
            history = CardHistory.new unless history
            history.insert_info(used_source, approved_source)
            history.save!
          end
        end
      end
    end
  end

  def insert_info(used_source, approved_source)
    self.creditcard = used_source.creditcard || approved_source.creditcard

    self.transacted_at = approved_source.used_at
    self.amount = approved_source.money
    self.amount_local = approved_source.money_foreign
    self.amount_dollar = approved_source.money_dollar
    self.country = approved_source.nation
    self.store_name = approved_source.store_name
    self.approved_status = approved_source.status
    self.approved_number = approved_source.approve_no
    self.paid_at = used_source.approved_at
  end

  def creditcard_name
    creditcard.cardno_long rescue ""
  end
end