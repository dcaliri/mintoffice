class HrinfoHistory < ActiveRecord::Base
  belongs_to :hrinfo
  belongs_to :account
end
