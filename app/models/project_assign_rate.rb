class ProjectAssignRate < ActiveRecord::Base
  belongs_to :assign_info, class_name: 'ProjectAssignInfo'
end