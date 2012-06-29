# encoding: UTF-8

class AppliesController < ApplicationController
  skip_before_filter :authorize
  before_filter :find_apply_admin

  def show
    @this_user = User.find(session[:user_id])
  end

  def new
    @this_user = User.prepare_apply(params)
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

  def find_apply_admin
    admin = Company.current_company.apply_admin
    raise ActiveRecord::RecordNotFound, "입사지원서 담당자를 지정하지 않았습니다. 회사정보에서 담당자를 지정해주세요." unless admin
  end
end