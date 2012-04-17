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


  def create
    commute.save!
    redirect_to commute_path(user)
  end
  def update
    commute.save!
    redirect_to commute_path(user)
  end

  def destroy
    commute.destroy
    redirect_to commute_path(user)
  end
end