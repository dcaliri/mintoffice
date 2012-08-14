class VacationTypeInfo < ActiveRecord::Base
  belongs_to :vacation_type
  belongs_to :used_vacation
end