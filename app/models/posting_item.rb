# encoding: UTF-8

class PostingItem < ActiveRecord::Base
  belongs_to :posting
  belongs_to :ledger_account

  # debit side - 차변
  # credit side - 대변
  validates_presence_of :ledger_account_id

  class << self
    def debits
      where(item_type: ITEM_TYPE.index("차변"))   # models.posting.debit
    end

    def credits
      where(item_type: ITEM_TYPE.index("대변"))   # models.posting.credit
    end

    def total_amount
      sum{|item| item.amount}
    end
  end

  ITEM_TYPE = ["차변", "대변"]    # models.posting.debit    models.posting.credit
  def item_type
    ITEM_TYPE[read_attribute(:item_type) || 0]
  end

  def item_type=(type_name)
    write_attribute(:item_type, ITEM_TYPE.index(type_name))
  end
end