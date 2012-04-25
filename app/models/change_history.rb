class ChangeHistory < ActiveRecord::Base
  belongs_to :changable, :polymorphic => true
  belongs_to :user
end