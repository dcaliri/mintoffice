# encoding: UTF-8

class SectionEnrollment::EnrollmentsController < ApplicationController
  skip_before_filter :authorize
  before_filter :find_apply_admin

  def dashboard
    @enrollment = current_user.enrollment
  end

  def edit
    @this_user = current_user
    @enrollment = current_user.enrollment
    @child_contact = @enrollment.contact || @enrollment.build_contact
  end

  def update
    @enrollment = current_user.enrollment
    if @enrollment.update_attributes(params[:enrollment])
      redirect_to [:dashboard, :enrollments], notice: '입사지원서가 저장되었습니다.'
    else
      @child_contact = @enrollment.contact
      render "edit"
    end
  end

  def attach_item
    @enrollment = current_user.enrollment
    @item = @enrollment.items.find_by_name(params[:name])
  end

  def attach
    @enrollment = current_user.enrollment
    item = @enrollment.find_or_create_item_by_name(params[:name])
    @attachment = Attachment.save_for(item, current_user, uploaded_file: params[:picture])
    redirect_to :back
  end

  def delete_attachment
    attachment = Attachment.where(user_id: current_user.id, id: params[:attachment_id]).last
    attachment.destroy
    redirect_to :back
  end

  def find_apply_admin
    admin = Company.current_company.apply_admin
    raise ActiveRecord::RecordNotFound, "입사지원서 담당자를 지정하지 않았습니다. 회사정보에서 담당자를 지정해주세요." unless admin
  end
end