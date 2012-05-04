class PayrollItem < ActiveRecord::Base
  belongs_to :payroll
  belongs_to :payroll_category
end