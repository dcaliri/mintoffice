# encoding: UTF-8

class SectionEnrollment::EnrollReportsController < ApplicationController
  before_filter :redirect_unless_enroll_permission

  def index
    @enrollments = Enrollment.applied.page(params[:page])
  end

  def show
    @enrollment = Enrollment.find(params[:id])
  end

  private
  def redirect_unless_enroll_permission
    user = User.current_user
    force_redirect unless (user.admin? or current_company.apply_admin == user)
  end
end