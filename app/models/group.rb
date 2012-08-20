class Group < ActiveRecord::Base
  has_and_belongs_to_many :people

  def self.people_in_group(group)
    self.where(:name => group).people
  end

  def self.admins
    where(name: "admin")
  end
end
