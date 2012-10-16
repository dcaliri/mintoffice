# encoding: UTF-8

module BankbooksHelper
  def options_for_bankbooks_select(bankbook = nil, opts = {})
    options = {no_holder: true}.merge(opts)

    id = bankbook ? bankbook.id : nil
    unless options[:collection]
      unless options[:no_holder]
        collection = Bankbook.scoped
      else
        collection = Bankbook.no_holder
      end
    else
      collection = options[:collection]
    end

    collection += [bankbook] if id and !collection.include? bankbook

    collection = collection.map{|resource| [resource.name, resource.id]}
    collection += [["없음", nil]]

    options_for_select(collection, id)
  end

  def options_for_bankname_select(bankbook = nil)
    code_collection = Bankbook::CODE_COLLECTION.map do |codes|
      ["#{codes[0]} (#{codes[1].to_s.rjust(3, '0')})", codes[1]]
    end

    id = bankbook ? bankbook.bank_code : nil
    options_for_select(code_collection, id)
  end
end