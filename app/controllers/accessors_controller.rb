# encoding: UTF-8

class AccessorsController < ApplicationController
  def create
    user = User.find(params[:accessor])
    resource = params[:resources_type].constantize.find(params[:resources_id])
    resource.accessors.permission(user, params[:access_type])
    redirect_to :back, notice: "성공적으로 권한을 설정하였습니다."
  end
end