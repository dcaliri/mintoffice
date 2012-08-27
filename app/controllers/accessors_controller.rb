# encoding: UTF-8

class AccessorsController < ApplicationController
  def create
    class_name, id = params[:accessor].split('-')

    owner = class_name.classify.constantize.find(id)
    resource = params[:resources_type].constantize.find(params[:resources_id])
    resource.accessors.permission(owner, params[:access_type])
    redirect_to :back, notice: t('controllers.accessors.set_permission')
  end

  def destroy
		person = AccessPerson.find(params[:accessor_id])
		person.destroy
		redirect_to :back, notice: t('controllers.accessors.delete_permission')
  end
end