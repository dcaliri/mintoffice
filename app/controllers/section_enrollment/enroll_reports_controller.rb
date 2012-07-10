# encoding: UTF-8

class SectionEnrollment::EnrollReportsController < ApplicationController
  def index
    @enrollments = Enrollment.page(params[:page])
  end

  def show
    @enrollment = Enrollment.find(params[:id])
  end
end