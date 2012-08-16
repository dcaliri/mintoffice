class VacationType < ActiveRecord::Base
  has_many :vacation_type_infos
  has_many :used_vacations, through: :vacation_type_infos
end