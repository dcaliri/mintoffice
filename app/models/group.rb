class Group < ActiveRecord::Base
  has_and_belongs_to_many :users
  
  def self.users_in_group(group)
    self.where(:name => group)[0].users
  end

  def self.admins
    where(name: "admin")
  end
end
