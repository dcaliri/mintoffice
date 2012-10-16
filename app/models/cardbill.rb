# encoding: UTF-8

class Cardbill < ActiveRecord::Base
  default_scope order('transdate desc')

  has_one :card_history
  belongs_to :creditcard
  has_many :expense_reports, as: :target

  include Historiable
  include Attachmentable
  include Reportable

  self.per_page = 20

  def history_info
    {
      :creditcard_id => proc { |cardbill, v| Creditcard.find(v).cardno }
    }
  end

  validates_presence_of :totalamount
  validates_presence_of :approveno
  validates_numericality_of :totalamount
  validates_numericality_of :amount

  before_save :strip_approve_no
  def strip_approve_no
    approveno.strip!
  end

  def check_unique_approve_no
    if creditcard.cardbills.except_me(self).unique?(self)
      errors.add(:approveno, I18n.t('# models.cardbill.already_exist'))
    end
  end

  def summary
    username = report.reporter.prev.fullname rescue ""
    "[카드영수증] #{username} 번호: #{cardno}, 사용일자: #{transdate}, 금액: #{ActionController::Base.helpers.number_to_currency(totalamount)}"
  end

  class << self
    def search(params)
      result = search_by_text(params[:query]).search_by_creditcard(params[:creditcard_id])
      if params[:empty_permission] == 'true'
        result.no_permission
      else
        result.access_list(params[:person])
      end
    end

    def search_by_text(query)
      query = "%#{query}%"
      where('storename like ?', query)
    end

    def search_by_creditcard(query)
      if query == nil or query == ""
        where("")
      else
        where("creditcard_id = ?", query)
      end
    end

    def except_me(cardbill)
      if cardbill.id
        where('id != ?', cardbill.id)
      else
        where('')
      end
    end

    def unique?(cardbill)
      exists?(approveno: cardbill.approveno, transdate: cardbill.transdate.all_year)
    end
  end

  
  def cardno_long
    unless self.creditcard.nil?
      self.creditcard.cardno_long
    else
      cardno
    end
  end

  def remain_amount_for_expense_report
    totalamount - expense_reports.total_amount
  end

end
