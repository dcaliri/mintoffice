class RequiredTag < ActiveRecord::Base
  belongs_to :tag
  validates_uniqueness_of :modelname, :scope => "tag_id"
end
