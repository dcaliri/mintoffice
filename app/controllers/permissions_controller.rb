# encoding: UTF-8

class PermissionsController < ApplicationController
  def index
    @permissions = Permission.find(:all, :order => "name")
  end

  def addaccount
    participant_type = params[:participant_type].to_sym
    collection_name  = params[:participant_type].to_s.tableize

    @permission = Permission.find_by_name(params[:id])

    if participant_type == :person
      @participant = Person.find_by_account_name(params[:participant_name])
    else
      @participant = Group.find_by_name(params[:participant_name])
    end

    if !@participant
      redirect_to @permission, alert: "등록되지 않은 사용자입니다."
    elsif @permission.send(collection_name).include?(@participant)
      redirect_to @permission, alert: "이미 등록된 사용자입니다."
    else
      @permission.send(collection_name) << @participant
      redirect_to @permission, notice: "성공적으로 사용자를 등록했습니다."
    end
  end

  def removeaccount
    model_name  = params[:participant_type].to_s.classify.constantize
    collection_name  = params[:participant_type].to_s.tableize

    @permission = Permission.find_by_name(params[:id])
    @participant = model_name.find(params[:participant_id])
    @permission.send(collection_name).delete(@participant)

    redirect_to @permission
  end

  def show
    @permission = Permission.find_or_create_by_name(params[:id])
  end

  def new
    @permission = Permission.new
  end

  def create
    @permission = Permission.new(params[:permission])
    @permission.save!
    redirect_to @permission, notice: t('common.messages.created', :model => Permission.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def destroy
    @permission = Permission.find(params[:id])
    @permission.destroy
    redirect_to @permission, notice: t('common.messages.destroyed', :model => Permission.model_name.human)
  end
end
