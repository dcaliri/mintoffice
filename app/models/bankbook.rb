class Bankbook < ActiveRecord::Base
  belongs_to :holder, polymorphic: true

  validates :name, presence: true
  validates :number, presence: true
  validates :account_holder, presence: true

  include Attachmentable

  class << self
    def no_holder
      where(holder_id: nil)
    end
  end
end