class Bankbook < ActiveRecord::Base
  belongs_to :holder, polymorphic: true

  include Attachmentable

  class << self
    def no_holder
      where(holder_id: nil)
    end
  end
end