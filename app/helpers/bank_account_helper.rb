module BankAccountHelper
  def bank_account_select_list(default, opts={})
    options = OpenStruct.new({list: BankAccount.access_list(current_person).all}.merge(opts))
    options_for_select(options.list.map{|bank| [bank.name_with_number, bank.id]}, default)
  end
end