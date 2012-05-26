class CommutesController < ApplicationController
  def redirect_unless_permission
  end

  before_filter :only => [:show] do |c|
    commutes_by_month.each do |w_commutes|
      w_commutes.each do |d,commute|
        c.save_attachment_id commute unless commute.nil?
      end
    end
  end

  before_filter :only => [:detail] { |c| c.save_attachment_id commute }

  before_filter :redirect_unless_admin, :only => :index

  expose(:users) { User(:protected)}
  expose(:user)
  expose(:commutes)
  expose(:commutes_by_month) do
    beginning_day = Time.zone.now.beginning_of_week
    ending_day = Time.zone.now.end_of_week
    w_commutes = []
    (0..3).each do |w|
      w_commutes << user.commutes.during((beginning_day - (w*7).day)..(ending_day - (w*7).day))
    end
    w_commutes
  end
  expose(:month) { params[:month].nil? ? 0 : params[:month].to_i }
  expose(:commute)

  def index
    @week = params[:week].to_i || 0
    @beginning_day = Time.zone.now.beginning_of_week - @week.week
    @ending_day = Time.zone.now.end_of_week - @week.week
    @commutes = Commute.every_during(@beginning_day..@ending_day)
    @commutes.values.each do |commute_by_users|
      commute_by_users.values.each do |commute|
        self.save_attachment_id commute unless commute.nil?
      end
    end
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