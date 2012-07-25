class DocumentOwner < ActiveRecord::Base
  belongs_to :document
  # belongs_to :account
  belongs_to :hrinfo
end
