class Tagging < ActiveRecord::Base
  belongs_to :target, :polymorphic => true
  belongs_to :tag
end