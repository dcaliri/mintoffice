class CardHistory < ActiveRecord::Base
  belongs_to :creditcard

  class << self
    def generate
      transaction do
        generate_shinhan_card_history
        generate_hyundai_card_history
      end
    end

    def generate_shinhan_card_history
      ShinhanCardUsedHistory.find_each do |used_history|
        approved_history = ShinhanCardApprovedHistory.find_by_approve_no(used_history.approve_no)
        next unless used_history and approved_history

        creditcard = Creditcard.find_by_short_name(used_history.card_no)
        next unless creditcard

        history = CardHistory.find_by_approved_number(used_history.approve_no)
        history = creditcard.card_histories.build unless history

        history.transacted_at = used_history.approved_at# + used_history.approved_time
        history.amount = used_history.price
        history.amount_local = used_history.money_foreign
        history.amount_dollar = used_history.money_krw
        history.country = used_history.foreign_country_name
        history.store_name = used_history.store_name + used_history.store_type + used_history.store_zipcode + used_history.store_addr1 + used_history.store_addr2
        history.approved_status = approved_history.purchase_status
        history.approved_number = approved_history.approve_no
        history.paid_at = approved_history.will_be_paied_at

        history.save!
      end
    end

    def generate_hyundai_card_history
      HyundaiCardUsedHistory.find_each do |used_history|
        approved_history = HyundaiCardApprovedHistory.find_by_approve_number(used_history.approve_no)
        next unless used_history and approved_history

        creditcard = Creditcard.find_by_short_name(used_history.card_no)
        next unless creditcard

        history = CardHistory.find_by_approved_number(used_history.approve_no)
        history = creditcard.card_histories.build unless history

        history.transacted_at = approved_history.transacted_date# + used_history.transacted_time
        history.amount = approved_history.money
        history.amount_local = approved_history.money_us
        history.amount_dollar = approved_history.money
        history.country = approved_history.nation
        history.store_name = approved_history.store_name
        history.approved_status = approved_history.status
        history.approved_number = approved_history.approve_number
        history.paid_at = used_history.approved_at

        history.save!
      end
    end
  end

  def creditcard_name
    creditcard.cardno_long rescue ""
  end
end