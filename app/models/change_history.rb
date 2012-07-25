class ChangeHistory < ActiveRecord::Base
  belongs_to :changable, :polymorphic => true
  # belongs_to :account
  belongs_to :employee
end