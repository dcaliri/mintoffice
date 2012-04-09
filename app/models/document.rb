class Document < ActiveRecord::Base
  belongs_to :project
  has_many :document_owners
  has_many :users, :through => :document_owners, :source => :user
  has_and_belongs_to_many :tags
  
  validates_presence_of :title
  
  def user_for_tag (tag_name)
    tag_names = self.tags.index_by {|t1| t1.name }
		all_user = User.all.index_by {|u| u.name}
		target_user = tag_names.keys & all_user.keys
		
    if (tag_names.keys.include? (tag_name)) && target_user.size == 1
      User.find_by_name(target_user[0])
    else
      nil
    end
  end
  
  def project_name
    if project then project.name else "none" end
  end
  
  def self.search(query)
    query = "%#{query || ""}%"
    joins(:project).joins(:tags).where('title like ? OR projects.name LIKE ? OR tags.name LIKE ?', query, query, query)
  end
end
