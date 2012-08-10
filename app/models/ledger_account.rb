# encoding: UTF-8

class LedgerAccount < ActiveRecord::Base
  has_many :items, class_name: 'PostingItem'

  CATEGORY_TYPE = [I18n.t('models.ledger_account.fund'),
                  I18n.t('models.ledger_account.asset'),
                  I18n.t('models.ledger_account.debt'),
                  I18n.t('models.ledger_account.expense'),
                  I18n.t('models.ledger_account.benefit')]
  def category
    CATEGORY_TYPE[read_attribute(:category) || 0]
  end

  def category=(category_name)
    write_attribute(:category, CATEGORY_TYPE.index(category_name))
  end
end