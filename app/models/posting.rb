# encoding: UTF-8

class Posting < ActiveRecord::Base
  has_many :items, class_name: 'PostingItem'

  belongs_to :expense_report

  REJECT_IF_EMPTY = proc { |attrs| attrs.all? { |k, v| k == "amount" ? v.blank? : true  } }
  accepts_nested_attributes_for :items, :allow_destroy => :true, :reject_if => REJECT_IF_EMPTY

  validate :check_total_amount
  def check_total_amount
    list = items.to_a
    credit_list = list.select{|item| item.item_type == I18n.t('models.posting.debit')}.sum(&:amount)
    debit_list = list.select{|item| item.item_type == I18n.t('models.posting.credit')}.sum(&:amount)
    unless credit_list == debit_list
      errors.add(:total_amount, I18n.t('models.posting.incorrect'))
    end
  end

  def total_amount
    items.credits.total_amount
  end
end