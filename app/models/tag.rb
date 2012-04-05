class Tag < ActiveRecord::Base
  has_and_belongs_to_many :documents
  has_many :tags
  
  validates_uniqueness_of :name

  def self.find_or_create_by_name(name)
    tag = Tag.find_by_name(name)
    if ! tag
      tag = Tag.create(:name => name)
    end
    tag
  end
  
  def self.related_documents(*arg)
    ds = nil
    arg.each do |a|
      t = Tag.find_by_name(a)
      d = []
      if ! t.nil?
        d = t.documents
      end
      if ds.nil?
        ds = d
      else
        ds = ds & d
      end
    end
    ds
  end
end