module Attachmentable
  extend ActiveSupport::Concern

  included do
    has_many :attachments, :as => :owner, :dependent => :destroy
    accepts_nested_attributes_for :attachments
  end
end