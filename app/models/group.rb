class Group < ActiveRecord::Base
  has_and_belongs_to_many :people

  has_many :subgroups, class_name: 'Group', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Group', foreign_key: 'parent_id'

  def self.people_in_group(group)
    self.where(:name => group).people
  end

  def self.admins
    where(name: "admin")
  end

  def parent_name
    parent.name rescue ""
  end
end
