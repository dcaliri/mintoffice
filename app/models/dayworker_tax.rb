class DayworkerTax < ActiveRecord::Base
  belongs_to :dayworker, :class_name => "Dayworker", :foreign_key => "dayworker_id"
end