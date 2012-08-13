class Dayworker < ActiveRecord::Base
  belongs_to :contact

  include Attachmentable
end