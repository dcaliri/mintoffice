class CommutesController < ApplicationController
  def redirect_unless_permission
  end

  expose(:users) { User(:protected)}
  expose(:user)
  expose(:commutes) { user.commutes.latest }
  expose(:commute)

  before_filter :only => [:detail] { |c| c.save_attachment_id commute }

  before_filter :redirect_unless_admin, :only => :index

  def index
    @users = User(:protected).enabled.page(params[:page])
  end

  def go!
    commute.go!
    redirect_to commute_path(user)
  rescue ActiveRecord::RecordInvalid
    render 'go'
  end

  def leave!
    commute.leave!
    redirect_to commute_path(user)
  end
end