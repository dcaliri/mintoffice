class GroupsController < ApplicationController
  expose(:groups) { Group.all }
  expose(:group)
  
  def create
    group.save!
    redirect_to groups_path
  end
  
  def update
    group.save!
    redirect_to group_path
  end
end
