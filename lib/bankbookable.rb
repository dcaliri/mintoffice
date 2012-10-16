module Bankbookable
  extend ActiveSupport::Concern

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
  end
end