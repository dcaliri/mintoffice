module Attachmentable
  extend ActiveSupport::Concern

  included do
    has_many :attachments, :as => :owner
    accepts_nested_attributes_for :attachments
  end
end