class Group < ActiveRecord::Base
  has_and_belongs_to_many :hrinfos
  
  def self.accounts_in_group(group)
    self.where(:name => group)[0].hrinfos
  end
end
