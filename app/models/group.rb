class Group < ActiveRecord::Base
  has_and_belongs_to_many :employees
  
  def self.people_in_group(group)
  	# FIXME: join 쿼리.
    self.where(:name => group).first.employees.map(&:person)
  end
end
