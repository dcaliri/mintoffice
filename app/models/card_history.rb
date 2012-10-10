class CardHistory < ActiveRecord::Base
  default_scope order('transacted_at DESC')

  belongs_to :cardbill
  belongs_to :used, polymorphic: true, foreign_type: "card_used_history_type", foreign_key: "card_used_history_id"
  belongs_to :approved, polymorphic: true, foreign_type: "card_approved_history_type", foreign_key: "card_approved_history_id"
  belongs_to :creditcard

  self.per_page = 20

  class << self
    def no_canceled
     where('approved_status NOT LIKE ?', I18n.t('models.card_approved_source.cancel'))
    end
    
    def by_date(date)
      if date == "all" or date.nil?
        scoped
      else
        date = Date.parse(date) if date.class == String && !date.blank?
        where(paid_at: date)
      end
    end

    def group_by_name_and_tax
      all.group_by{|card_history| card_history.creditcard.cardno_long }.map do |name, card_histories|
        {name: name, tax: card_histories.sum{|card| card.tax}}
      end
    end

    def oldest_at
    resource = order('transacted_at DESC').last
    if resource && resource.transacted_at
      resource.transacted_at
    else
      Time.zone.now
    end
  end

    def total_price
      sum{|history| history.amount }
    end

    def find_empty_cardbill
      no_canceled.where(cardbill_id: nil)
    end

    def generate_cardbill(owner)
      total_count = 0
      find_empty_cardbill.each do |history|

        cardbill = history.creditcard.cardbills.build(
          amount: history.amount,
          approveno: history.approved_number,
          totalamount: history.amount,
          transdate: history.transacted_at,
          storename: history.store_name
        )

        cardbill.card_history = history

        report = cardbill.build_report

        raise cardbill.errors.inspect if cardbill.invalid?

        cardbill.save!

        cardbill.report.reporters.destroy_all
        cardbill.report.accessors.destroy_all
        cardbill.report.permission owner, :write

        total_count += 1
      end
      total_count
    end

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

  def creditcard_name
    creditcard.cardno_long rescue ""
  end
end