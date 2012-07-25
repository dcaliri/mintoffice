class Payroll < ActiveRecord::Base
  
  REJECT_IF_EMPTY = proc { |a| a['amount'].blank? }
  
  # belongs_to :account
  belongs_to :employee
  has_many :items, :class_name => "PayrollItem"
  accepts_nested_attributes_for :items, :allow_destroy => :true, :reject_if => REJECT_IF_EMPTY
  
end