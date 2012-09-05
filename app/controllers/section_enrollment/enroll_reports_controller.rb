# encoding: UTF-8

class SectionEnrollment::EnrollReportsController < ApplicationController
  before_filter :redirect_unless_enroll_permission

  def index
    @enrollments = current_company.enrollments.applied.page(params[:page])
  end

  def show
    @enrollment = current_company.enrollments.find(params[:id])
  end

  private
  def redirect_unless_enroll_permission
    force_redirect unless (current_person.admin? or current_company.apply_admin == current_person)
  end
end