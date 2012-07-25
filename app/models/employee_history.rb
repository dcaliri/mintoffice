class EmployeeHistory < ActiveRecord::Base
  belongs_to :employee
  belongs_to :account
end
