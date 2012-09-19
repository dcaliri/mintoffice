class MigrateCardSourcesToCardHistories < ActiveRecord::Migration
  class CardUsedSource < ActiveRecord::Base; end
  class CardApprovedSource < ActiveRecord::Base; end
  class ShinhanCardUsedHistory < ActiveRecord::Base; end
  class HyundaiCardUsedHistory < ActiveRecord::Base; end
  class ShinhanCardApprovedHistory < ActiveRecord::Base; end
  class HyundaiCardApprovedHistory < ActiveRecord::Base; end

  def up
    CardUsedSource.find_each do |used|
      type = (used.sales_statement.nil? and used.prepayment_statement.nil?) ? :shinhan : :hyundai

      if type == :shinhan
        ShinhanCardUsedHistory.create! do |history|
          history.card_no = used.card_no
          history.bank_account = used.bank_account
          history.bank_name = used.bank_name
          history.card_holder_name = used.card_holder_name
          history.used_area = used.used_area
          history.approve_no = used.approve_no
          history.approved_at = used.approved_at
          history.approved_time = used.approved_time
          history.sales_type = used.sales_type
          history.money_krw = used.money_krw
          history.money_foreign = used.money_foreign
          history.price = used.price
          history.tax = used.tax
          history.tip = used.tip
          history.monthly_duration = used.monthly_duration
          history.exchange_krw = used.exchange_krw
          history.foreign_country_code = used.foreign_country_code
          history.foreign_country_name = used.foreign_country_name
          history.store_business_no = used.store_business_no
          history.store_name = used.store_name
          history.store_type = used.store_type
          history.store_zipcode = used.store_zipcode
          history.store_addr1 = used.store_addr1
          history.store_addr2 = used.store_addr2
          history.store_tel = used.store_tel
        end
      else
        HyundaiCardUsedHistory.create! do |history|
          history.used_at = used.used_at
          history.card_no = used.card_no
          history.card_holder_name = used.card_holder_name
          history.store_name = used.store_name
          history.tax_type = used.tax_type
          history.price = used.price
          history.approve_no = used.approve_no
          history.sales_statement = used.sales_statement
          history.nation_statement = used.nation_statement
          history.money_krw = used.money_krw
          history.exchange_krw = used.exchange_krw
          history.exchange_us = used.money_foreign
          history.prepayment_statement = used.prepayment_statement
          history.accepted_at = used.accepted_at
          history.approved_at = used.approved_at
          history.apply_sales_statement = used.apply_sales_statement
          history.purchase_statement = used.purchase_statement
        end
      end
    end

    CardApprovedSource.find_each do |approved|
      type = approved.nation_statement.nil? ? :shinhan : :hyundai

      if type == :shinhan
        ShinhanCardApprovedHistory.create! do |history|
          history.used_at = approved.used_at
          history.approve_no = approved.approve_no
          history.card_name = approved.card_no
          history.card_holder_name = approved.card_holder_name
          history.store_name = approved.store_name
          history.money = approved.money
          history.used_type = approved.used_type
          history.monthly_duration = approved.monthly_duration
          history.card_type = approved.card_type
          history.canceled_at = approved.canceled_at
          history.purchase_status = approved.status
          history.will_be_paied_at = approved.will_be_paied_at
        end
      else
        HyundaiCardApprovedHistory.create! do |history|
          history.transacted_date = approved.used_at
          history.transacted_time = approved.used_at
          history.card_number = approved.card_no
          history.money = approved.money
          history.money_us = approved.money_us
          history.card_holder_name = approved.card_holder_name
          history.store_name = approved.store_name
          history.nation = approved.nation
          history.status = approved.status
          history.approve_number = approved.approve_no
          history.nation_statement = approved.nation_statement
          history.refuse_reason = approved.refuse_reason
        end
      end
    end
  end

  def down
    ShinhanCardUsedHistory.destroy_all
    HyundaiCardUsedHistory.destroy_all
    ShinhanCardApprovedHistory.destroy_all
    HyundaiCardApprovedHistory.destroy_all
  end
end
