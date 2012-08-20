module GroupsHelper
  def options_for_groups_select(group, parent)
    id = parent ? parent.id : 0
    options_from_collection_for_select(Group.all - [group], 'id', 'name', id)
  end
end