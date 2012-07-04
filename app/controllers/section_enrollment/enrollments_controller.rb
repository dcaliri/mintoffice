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
    # @child_contact = @enrollment.build_contact
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
    item = @enrollment.find_or_create_custom_item(params[:name])
    @attachment = Attachment.save_for(item, current_user, uploaded_file: params[:picture])
    redirect_to :back
  end

  def delete_attachment
    attachment = Attachment.where(user_id: current_user.id, id: params[:attachment_id]).last
    attachment.destroy
    redirect_to :back
  end

=begin
  def show
    @this_user = User.find(session[:user_id])
  end

  def edit
    @this_user = current_user
  end

  def create
    @this_user = User.new(params[:user])
    @this_user.save_apply(url_for(@this_user.hrinfo.redirect_when_reported))
    redirect_to [:complete, :apply]
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def update
    @this_user = current_user
    @this_user.update_attributes!(params[:user])
    redirect_to :apply, notice: "성공적으로 입사지원서를 수정했습니다."
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end
=end

  def find_apply_admin
    admin = Company.current_company.apply_admin
    raise ActiveRecord::RecordNotFound, "입사지원서 담당자를 지정하지 않았습니다. 회사정보에서 담당자를 지정해주세요." unless admin
  end

end