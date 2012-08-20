module BankbookHelper
  def bankbooks_select
    options_from_collection_for_select(Bankbook.all, 'id', 'name')
  end
end