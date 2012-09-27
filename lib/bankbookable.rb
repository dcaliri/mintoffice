module Bankbookable
  extend ActiveSupport::Concern

  module ClassMethods
    def no_bankbook
      includes(:bankbook).all.select{|resource| !resource.bankbook}
    end
  end

private
  def save_bankook
    unless bankbook_id.blank?
      self.bankbook = Bankbook.find(bankbook_id)
    else
      self.bankbook = nil
    end
  end

  included do 
    has_one :bankbook, as: :holder

    attr_accessor :bankbook_id
    before_save :save_bankook

    delegate :name, :to => :bankbook, prefix: true, allow_nil: true

    extend ClassMethods
  end
end