class ProjectAssignInfo < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :rates, class_name: 'ProjectAssignRate'

  def rate(period)
    100
  end
end