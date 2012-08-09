class ExceptColumn < ActiveRecord::Base
  belongs_to :hrifo
  belongs_to :model, polymorphic: true
  serialize :columns, Hash

  class << self
    def default_columns_by_key(key)
      where(model_name: key, default: true).first.columns rescue nil
    end

    def default
      where(default: true)
    end
  end
end