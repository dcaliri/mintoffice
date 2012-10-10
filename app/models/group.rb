class Group < ActiveRecord::Base
  has_and_belongs_to_many :people
  has_and_belongs_to_many :permissions

  has_many :subgroups, class_name: 'Group', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Group', foreign_key: 'parent_id'

  has_many :project_infos, class_name: "ProjectAssignInfo", as: :participant
  has_many :projects, through: :project_infos

  has_many :accessors, class_name: 'AccessPerson', as: 'owner'

  def self.people_in_group(group)
    self.where(:name => group).people
  end

  def people_with_all_subgroup
    result = people
    return result if subgroups.empty?
    (result + subgroups.map {|subgroup| subgroup.people_with_all_subgroup}).flatten.uniq
  end

  def all_subgroups
    return [self] if subgroups.empty?
    subgroups.map {|subgroup| subgroup.all_subgroups}.flatten
  end

  def self.admins
    where(name: "admin")
  end

  def admin?
    self.name == "admin"
  end

  def parent_name
    parent.name rescue ""
  end
end
