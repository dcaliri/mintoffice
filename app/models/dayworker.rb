class Dayworker < ActiveRecord::Base
  has_one :contact, :class_name => "Contact", :foreign_key => "contact_id"
end