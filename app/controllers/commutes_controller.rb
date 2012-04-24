class CommutesController < ApplicationController
  def redirect_unless_permission
  end

  expose(:users) { User(:protected).page(params[:page]) }
  expose(:user)
  expose(:commutes) { user.commutes.latest }
  expose(:commute)

  before_filter :redirect_unless_admin, :only => :index

  def detail
    @attachments = Attachment.for_me(commute)
    session[:attachments] = [] if session[:attachments].nil?
    @attachments.each { |at| session[:attachments] << at.id }
  end

  def go!
    commute.go!
    Attachment.save_for(commute, @user, params[:attachment])
    redirect_to commute_path(user)
  end

  def leave!
    commute.leave!
    Attachment.save_for(commute, @user, params[:attachment])
    redirect_to commute_path(user)
  end
end