# encoding: UTF-8

class LedgerAccount < ActiveRecord::Base
  has_many :posting_items

  CATEGORY_TYPE = ["자본", "자산", "부채", "비용", "수익"]
  def category
    CATEGORY_TYPE[read_attribute(:category) || 0]
  end

  def category=(category_name)
    write_attribute(:category, CATEGORY_TYPE.index(category_name))
  end
end