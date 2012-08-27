# encoding: UTF-8

module AccessorsHelper
  def options_for_access_people_select
    people = Person.with_account.without_retired.map{|person| ["[개인] " + person.fullname, 'person-' + person.id.to_s]}
    groups = Group.all.map{|group| ["[그룹] " + group.name, 'group-' + group.id.to_s]}
    collection = people + groups

    options_for_select(collection)
  end
end