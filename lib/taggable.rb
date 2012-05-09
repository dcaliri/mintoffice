module Taggable
  extend ActiveSupport::Concern

  def tag_list
    tags.map {|tag| tag.name }.join ", "
  end

  included do
    has_many :taggings, :as => :target
    has_many :tags, :through => :taggings
  end
end