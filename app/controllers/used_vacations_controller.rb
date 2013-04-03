# encoding: UTF-8

class UsedVacationsController < ApplicationController
  def redirect_unless_permission; end

  expose(:vacation)
  expose(:used_vacations) { vacation.used }
  expose(:used_vacation)
  expose(:employee) do
    vacation = Vacation.find(params[:vacation_id]) if params[:vacation_id]
    vacation ||= UsedVacation.find(params[:id]).vacation if !vacation and params[:id]
    
    vacation.employee
  end

  before_filter {|controller| controller.redirect_unless_me(employee)}

  def show
    @used_vacation = UsedVacation.find(params[:id])
  end

  def create
    used_vacation.save!
    redirect_to [vacation, used_vacation], notice: t('controllers.used_vacations.reports')
  end

  def update
    if used_vacation.valid?
      used_vacation.save!
      redirect_to [vacation, used_vacation]
    else
      render 'edit'
    end
  end

  def approve
    used_vacation.approve = params[:approve]
    used_vacation.save
    if params[:approve] == "true"
      approve_txt = I18n.t("used_vacations.approval_completed")
    else
      approve_txt = I18n.t("used_vacations.approval_waiting")
    end
    redirect_to vacation_path(employee)
  end

  def destroy
    used_vacation.destroy
    redirect_to vacation_path(employee)
  end
end