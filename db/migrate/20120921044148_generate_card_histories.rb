class GenerateCardHistories < ActiveRecord::Migration
  class Cardbill < ActiveRecord::Base
    has_one :card_history
  end

  class CardHistory < ActiveRecord::Base
    belongs_to :cardbill
    belongs_to :used, polymorphic: true, foreign_type: "card_used_history_type", foreign_key: "card_used_history_id"
    belongs_to :approved, polymorphic: true, foreign_type: "card_approved_history_type", foreign_key: "card_approved_history_id"
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

          if used_history.approved_at and used_history.approved_time
            history.transacted_at = DateTime.new(
              used_history.approved_at.year,
              used_history.approved_at.month,
              used_history.approved_at.day,
              used_history.approved_time.hour, 
              used_history.approved_time.min,
              used_history.approved_time.sec
            )
          end

          history.amount = used_history.price
          history.amount_local = used_history.money_foreign
          history.amount_dollar = used_history.money_krw
          history.country = used_history.foreign_country_name
          history.store_name = used_history.store_name + used_history.store_type + used_history.store_zipcode + used_history.store_addr1 + used_history.store_addr2
          history.approved_status = approved_history.purchase_status
          history.approved_number = approved_history.approve_no
          history.paid_at = approved_history.will_be_paied_at

          history.used = used_history
          history.approved = approved_history
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

          if approved_history.transacted_date and approved_history.transacted_time
            history.transacted_at = DateTime.new(
              approved_history.transacted_date.year,
              approved_history.transacted_date.month,
              approved_history.transacted_date.day,
              approved_history.transacted_time.hour, 
              approved_history.transacted_time.min,
              approved_history.transacted_time.sec
            )
          end
          
          history.amount = approved_history.money
          history.amount_local = approved_history.money_us
          history.amount_dollar = approved_history.money
          history.country = approved_history.nation
          history.store_name = approved_history.store_name
          history.approved_status = approved_history.status
          history.approved_number = approved_history.approve_number
          history.paid_at = used_history.approved_at

          history.used = used_history
          history.approved = approved_history
          history.save!
        end
      end
    end
  end

  def up
    # CardHistory.generate
    # Cardbill.find_each do |cardbill|
    #   history = CardHistory.find_by_approved_number(cardbill.approveno)
    #   if history
    #     cardbill.card_history = history
    #   end
    # end
  end

  def down
    CardHistory.destroy_all
  end
end
