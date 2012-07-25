# encoding: UTF-8

class UsedVacationsController < ApplicationController
  def redirect_unless_permission
  end

  expose(:vacation)
  expose(:used_vacations) { vacation.used }
  expose(:used_vacation)

  expose(:account) { vacation.employee.account }

  before_filter {|controller| controller.redirect_unless_me(account)}
  before_filter :another_account_cant_access_yearly, :only => [:edit]

  def create
    used_vacation.save!
    # Boxcar.send_to_boxcar_group("admin",used_vacation.vacation.account.employee.fullname, I18n.t("used_vacations.new.link"))
    redirect_to [vacation, used_vacation], notice: t('controllers.used_vacations.reports')
  end

  def update
    if used_vacation.valid?
      used_vacation.save!
      redirect_to [vacation, used_vacation]
    else
      render :action => :edit
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
    redirect_to vacation_path(account)
  end

  def destroy
    used_vacation.destroy
    redirect_to vacation_path(account)
  end

  def another_account_cant_access_yearly
    force_redirect if !current_account.admin?
  end
end