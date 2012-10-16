class PayrollItem < ActiveRecord::Base
  belongs_to :payroll
  belongs_to :payroll_category

  class << self
    def total
      sum(:amount)
    end
  end
end