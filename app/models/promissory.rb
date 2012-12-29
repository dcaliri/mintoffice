class Promissory < ActiveRecord::Base
  include Reportable

  class << self
    def total_amount
      sum(:amount)
    end
  end
end