class Bankbook < ActiveRecord::Base
  belongs_to :holder, polymorphic: true

  include Attachmentable
end