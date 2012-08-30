# encoding: UTF-8

class SectionEnrollment::EnrollmentsController < ApplicationController
  layout "login", :only => :index

  skip_before_filter :authorize
  before_filter :find_apply_admin, :except => :index
  before_filter :find_enrollment, :except => :index

  def edit
    @contact = @enrollment.person.contact || @enrollment.person.build_contact
  end

  def update
    if @enrollment.update_attributes(params[:enrollment])
      redirect_to [:dashboard, :enrollments], notice: '입사지원서가 저장되었습니다.'
    else
      @contact = @enrollment.contact
      render "edit"
    end
  end

  def attach_item
    @item = @enrollment.items.find_by_name(params[:name])
  end

  def attach
    item = @enrollment.find_or_create_item_by_name(params[:name])
    @attachment = Attachment.save_for(item, current_employee, uploaded_file: params[:picture])
    redirect_to :back
  end

  def delete_attachment
    attachment = Attachment.where(employ_id: current_employee.id, id: params[:attachment_id]).last
    attachment.destroy

    item = @enrollment.items.find_by_name(params[:name])
    item.destroy if item.attachments.count == 0

    redirect_to :back
  end

  private
  def find_enrollment
    @enrollment = current_person.enrollment || current_person.create_enrollment!(company_id: current_company)
  end

  def find_apply_admin
    @apply_admin = Company.current_company.apply_admin
    raise ActiveRecord::RecordNotFound, "입사지원서 담당자를 지정하지 않았습니다. 회사정보에서 담당자를 지정해주세요." unless @apply_admin
  end
end