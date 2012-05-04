class Payroll < ActiveRecord::Base
  belongs_to :user
  has_many :payroll_items
end