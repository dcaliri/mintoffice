# encoding: UTF-8

class UsedVacationsController < ApplicationController
  def redirect_unless_permission
  end

  expose(:vacation)
  expose(:used_vacations) { vacation.used }
  expose(:used_vacation)

  expose(:user) { vacation.user }

  before_filter {|controller| controller.redirect_unless_me(user)}

  def create
    used_vacation.save!
    # Boxcar.send_to_boxcar_group("admin",used_vacation.vacation.user.hrinfo.fullname, I18n.t("used_vacations.new.link"))
    redirect_to [vacation, used_vacation], notice: "연차를 신청하였습니다. 신청 후에는 결제를 올려주세요."
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
    redirect_to vacation_path(user)
  end

  def destroy
    used_vacation.destroy
    redirect_to vacation_path(user)
  end
end