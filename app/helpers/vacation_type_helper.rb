module VacationTypeHelper
  def vacation_type_select_list(default, opts={})
    options = OpenStruct.new({list: VacationType.all}.merge(opts))
    options_for_select(options.list.map{|vacation_type| [vacation_type.title, vacation_type.id]}, default)
  end
end