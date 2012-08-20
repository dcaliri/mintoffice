module BankbooksHelper
  def options_for_bankbooks_select(bankbook = nil)
    id = bankbook ? bankbook.id : nil
    options_from_collection_for_select(Bankbook.all, 'id', 'name', id)
  end
end