# encoding: UTF-8

class PermissionsController < ApplicationController
  def index
    @permissions = Permission.find(:all, :order => "name")
  end

  def addaccount
    @permission = Permission.find(params[:id])
    @account = Account.find_by_name(params[:accountname])
    if !@account
      redirect_to @permission, alert: "등록되지 않은 사용자입니다."
    elsif @permission.people.include?(@account.person)
      redirect_to @permission, alert: "이미 등록된 사용자입니다."
    else
      @permission.people << @account.person
      redirect_to @permission, notice: "성공적으로 사용자를 등록했습니다."
    end
  end

  def removeaccount
    @person = Person.find params[:person_id]
    @permission = Permission.find(params[:id])
    @permission.people.delete(@person)

    redirect_to @permission
  end

  def show
    @permission = Permission.find(params[:id])
  end

  def new
    @permission = Permission.new
  end

  def edit
    @permission = Permission.find(params[:id])
  end

  def create
    @permission = Permission.new(params[:permission])
    @permission.save!
    redirect_to @permission, notice: t('common.messages.created', :model => Permission.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def update
    params[:permission][:person_ids] ||= []
    @permission = Permission.find(params[:id])
    @permission.update_attributes!(params[:permission])
    redirect_to @permission, notice: I18n.t("common.messages.updated", :model => Permission.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def destroy
    @permission = Permission.find(params[:id])
    @permission.destroy
  end
end
