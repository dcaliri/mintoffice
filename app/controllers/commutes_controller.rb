class CommutesController < ApplicationController
  def redirect_unless_permission
  end

  before_filter :only => [:show, :detail] { |c| c.redirect_unless_me(user) }
  before_filter :redirect_unless_admin, :only => [:index, :go, :leave, :go!, :leave!]

  expose(:users) { User(:protected) }
  expose(:user)

  before_filter :only => [:index]  { |c| commutes_everyone.values.collect(&:values).flatten.each { |commute| self.save_attachment_id commute unless commute.nil? } }
  expose(:commutes_everyone) { Commute.every_during((week_begin_time - page.week)..(week_end_time - page.week)) }

  before_filter :only => [:show] { |c| commutes_by_month.each.collect(&:values).flatten.each { |commute| c.save_attachment_id commute unless commute.nil? } }
  expose(:commutes_by_month) { (0..3).collect {|w| user.commutes.during((week_begin_time - (4*page+w).week)..(week_end_time - (4*page+w).week)) } }

  before_filter :only => [:detail] { |c| c.save_attachment_id commute }
  expose(:commute)

  expose(:page) { params[:page].nil? ? 0 : params[:page].to_i }
  expose(:week_begin_time) { Time.zone.now.beginning_of_week }
  expose(:week_end_time) { Time.zone.now.end_of_week }
  
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