# encoding: UTF-8

module BankbooksHelper
  def options_for_bankbooks_select(bankbook = nil)
    id = bankbook ? bankbook.id : nil
    collection = Bankbook.no_holder
    collection += [bankbook] if id

    collection = collection.map{|resource| [resource.name, resource.id]}
    collection += [["없음", nil]]

    options_for_select(collection, id)
  end
end