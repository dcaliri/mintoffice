class PaymentsController < ApplicationController
  expose(:users) do
    users = if @user.ingroup?(:admin)
              User
            else
              User.where(name: @user.name)
            end
   users.page(params[:page])
  end

  expose(:user)
end