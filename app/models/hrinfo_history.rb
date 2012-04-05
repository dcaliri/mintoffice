class HrinfoHistory < ActiveRecord::Base
  belongs_to :hrinfo
  belongs_to :user
end
