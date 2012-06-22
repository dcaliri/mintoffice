class AppliesController < ApplicationController
  skip_before_filter :authorize

  def new
    @this_user = User.prepare_apply(params)
  end

  def create
    @this_user = User.new(params[:user])
    @this_user.save!
    redirect_to [:complete, :apply]
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end
end