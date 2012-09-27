class Payroll < ActiveRecord::Base
  REJECT_IF_EMPTY = proc { |a| a['amount'].blank? }

  belongs_to :employee
  has_many :items, :class_name => "PayrollItem"
  accepts_nested_attributes_for :items, :allow_destroy => :true, :reject_if => REJECT_IF_EMPTY


  scope :latest, order('payday DESC')
  scope :oldest, order('payday ASC')

  class << self
    def by_period(period)
      if period
        period_scope = (period.beginning_of_month..period.end_of_month)
        where(payday: period_scope)
      else
        scoped
      end
    end
  end

  def payable
    items.joins(:payroll_category).merge(PayrollCategory.payable)
  end

  def deductable
    items.joins(:payroll_category).merge(PayrollCategory.deductable)
  end

  def payable_total
    payable.total rescue 0
  end

  def deductable_total
    deductable.total rescue 0
  end

  def difference_total
    payable_total - deductable_total
  end
end