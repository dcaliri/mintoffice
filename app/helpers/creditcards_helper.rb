# encoding: UTF-8

module CreditcardsHelper
  def options_for_creditcard_select(default = nil)
    default = nil if default.blank?
    
    collection = Creditcard.all.map{|creditcard| [creditcard.cardno_long, creditcard.id]}
    collection.unshift ["전체", nil]

    options_for_select(collection, default)
  end
end