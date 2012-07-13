# encoding: UTF-8

class LedgerAccount < ActiveRecord::Base
  # has_many :posting_items
  has_many :items, class_name: 'PostingItem'

  CATEGORY_TYPE = ["자본", "자산", "부채", "비용", "수익"]
  # listing
  # models.ledger_account.fund
  # models.ledger_account.asset
  # models.ledger_account.debt
  # models.ledger_account.expense
  # models.ledger_account.benefit
  def category
    CATEGORY_TYPE[read_attribute(:category) || 0]
  end

  def category=(category_name)
    write_attribute(:category, CATEGORY_TYPE.index(category_name))
  end
end