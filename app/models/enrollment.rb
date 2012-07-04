# encoding: utf-8
class Enrollment < ActiveRecord::Base
	belongs_to :user
	has_one :contact, :as => :target
	
	has_many :items, class_name: 'EnrollmentItem', dependent: :destroy

	accepts_nested_attributes_for :contact, :allow_destroy => :true

	def find_or_create_custom_item(name)
		if item = self.items.find_by_name(name)
			item
		else
			self.items.create!(name: name)
		end

	end
end
