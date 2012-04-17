class CommutesController < ApplicationController
  expose(:users) do
    users = if @user.ingroup?(:admin)
              User
            else
              User.where(name: @user.name)
            end
   users.page(params[:page])
  end
  expose(:user)
  expose(:commutes) { user.commutes }
  expose(:commute)

  def detail
    @attachments = Attachment.for_me(commute)
    session[:attachments] = [] if session[:attachments].nil?
    @attachments.each { |at| session[:attachments] << at.id }
  end

  def create
    commute.save!
    Attachment.save_for(commute, @user, params[:attachment])
    redirect_to commute_path(user)
  end

  def edit
    @attachments = Attachment.for_me(commute)
  end

  def update
    commute.save!
    Attachment.save_for(commute, @user, params[:attachment])
    redirect_to commute_path(user)
  end

  def destroy
    commute.destroy
    redirect_to commute_path(user)
  end
end