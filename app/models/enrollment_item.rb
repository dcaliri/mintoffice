class EnrollmentItem < ActiveRecord::Base
  attr_accessible :enrollment_id, :name
  belongs_to :enrollment

  include Attachmentable
end
