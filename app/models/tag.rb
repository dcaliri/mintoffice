class Tag < ActiveRecord::Base
  belongs_to :company
  has_many :taggings
  has_many :targets, through: :taggings
  has_many :tags

  validates_uniqueness_of :name, scope: :company_id

  def self.find_or_create(params)
    find_or_create_by_name(params[:name])
  end

  def self.find_or_create_by_name(name)
    tag = find_by_name(name)
    if ! tag
      tag = create(:name => name)
    end
    tag
  end

  def self.related_documents(*arg)
    ds = nil
    arg.each do |a|
      t = find_by_name(a)
      d = []
      if ! t.nil?
        d = t.taggings.map{|tagging| tagging.target}
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