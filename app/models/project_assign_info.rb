class ProjectAssignInfo < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  def rate(period)
    100
  end
end