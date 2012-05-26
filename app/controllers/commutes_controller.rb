class CommutesController < ApplicationController
  def redirect_unless_permission
  end

  before_filter :only => [:show] do |c|
    commutes_by_month.each do |w_commutes|
      w_commutes.each do |commute|
        c.save_attachment_id commute
      end
    end
  end


  expose(:users) { User(:protected)}
  expose(:user)
  expose(:commutes)
  expose(:commutes_by_month) do
    w_commutes = []
    ((month*4) .. ((month+1)*4)).each do |w|
      w_commutes << user.commutes.this_week(w)
    end
    w_commutes
  end
  expose(:month) { params[:month].nil? ? 0 : params[:month].to_i }
  expose(:commute)

  before_filter :only => [:detail] { |c| c.save_attachment_id commute }

  before_filter :redirect_unless_admin, :only => :index

  def index
    @hrinfos = Hrinfo.where(:retired_on => nil).page(params[:page])
    @users = User(:protected).enabled.page(params[:page])
  end

  def show
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