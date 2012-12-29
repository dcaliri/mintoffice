class GroupsController < ApplicationController
  expose(:groups) { Group.scoped }
  expose(:group)

  def create
    group.save!
    redirect_to :groups
  end

  def update
    group.people = [] if params[:group][:person_ids].nil?
    group.save!
    redirect_to group
  end
end
