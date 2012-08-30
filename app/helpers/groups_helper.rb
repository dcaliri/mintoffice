# encoding: UTF-8

module GroupsHelper
  def options_for_groups_select(group, parent)
    id = parent ? parent.id : 0

    collection = Group.all.map{|resource| [resource.name, resource.id]} - [group]
    collection += [["없음", nil]]

    options_for_select(collection, id)
  end
end