class ExceptColumn < ActiveRecord::Base
  belongs_to :user
  belongs_to :model, polymorphic: true
  serialize :columns, Hash

  class << self
    def default
      where(default: true)
    end
  end
end