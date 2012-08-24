# encoding: UTF-8

module GroupsHelper
  def options_for_groups_select(group, parent)
    id = parent ? parent.id : 0

    collection = Group.all.map{|resource| [resource.name, resource.id]} - [group]
    collection += [["없음", nil]]

    options_for_select(collection, id)
    # options_from_collection_for_select(collection, 'id', 'name', id)
  end

  def name_with_id(person)
    if person.employee
      "#{person.fullname}(#{person.name})"
    else
      person.name
    end
  end
end