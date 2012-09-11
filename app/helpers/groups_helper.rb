# encoding: UTF-8

module GroupsHelper
  def options_for_groups_select(group, parent)
    id = parent ? parent.id : 0

    collection = Group.all.map{|resource| [resource.name, resource.id]} - [group]
    collection += [["없음", nil]]

    options_for_select(collection, id)
  end

  def options_for_people_and_group_select
    people = Person.with_account.without_retired.map{|person| ["[개인] #{person.fullname}(#{person.account.name})", 'person-' + person.id.to_s]}
    groups = Group.all.map{|group| ["[그룹] #{group.name}", 'group-' + group.id.to_s]}
    collection = people + groups

    options_for_select(collection)
  end
end