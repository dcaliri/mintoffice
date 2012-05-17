class ExpenseReport < ActiveRecord::Base
  belongs_to :hrinfo
  belongs_to :target, polymorphic: true
  belongs_to :project
end