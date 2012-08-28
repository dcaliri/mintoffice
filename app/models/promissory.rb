class Promissory < ActiveRecord::Base
  class << self
    def total_amount
      sum(:amount)
    end
  end
end