# encoding: UTF-8

class SectionEnrollment::EnrollmentsController < ApplicationController
  skip_before_filter :authorize
  before_filter :find_apply_admin
  before_filter :find_enrollment, :except => :delete_attachment

  def edit
    @child_contact = @enrollment.contact || @enrollment.build_contact
  end

  def update
    if @enrollment.update_attributes(params[:enrollment])
      redirect_to [:dashboard, :enrollments], notice: '입사지원서가 저장되었습니다.'
    else
      @child_contact = @enrollment.contact
      render "edit"
    end
  end

  def attach_item
    @item = @enrollment.items.find_by_name(params[:name])
  end

  def attach
    item = @enrollment.find_or_create_item_by_name(params[:name])
    @attachment = Attachment.save_for(item, current_user, uploaded_file: params[:picture])
    redirect_to :back
  end

  def delete_attachment
    attachment = Attachment.where(user_id: current_user.id, id: params[:attachment_id]).last
    attachment.destroy
    redirect_to :back
  end

  private
  def find_enrollment
    @enrollment = current_user.enrollment
  end

  def find_apply_admin
    @apply_admin = Company.current_company.apply_admin
    raise ActiveRecord::RecordNotFound, "입사지원서 담당자를 지정하지 않았습니다. 회사정보에서 담당자를 지정해주세요." unless @apply_admin
  end
end