class Group < ActiveRecord::Base
  has_and_belongs_to_many :employees
  
  def self.accounts_in_group(group)
    self.where(:name => group)[0].employees
  end
end
