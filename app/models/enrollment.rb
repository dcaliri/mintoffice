# encoding: utf-8
class Enrollment < ActiveRecord::Base
	belongs_to :user
	has_one :contact, :as => :target
end
