class PaymentsController < ApplicationController
  expose(:users) { User(:protected) }
  expose(:user)
  expose(:payments) { user.payments }
  expose(:payment)

  def redirect_unless_permission
  end

  before_filter {|controller| controller.redirect_unless_me(user)}

  def index
    @users = User(:protected).enabled.page(params[:page])
  end

  def create
    payment.save!
    redirect_to payment_path(user)
  end

  def create_yearly
    payments.create_yearly!(params[:payments])
    redirect_to payment_path(user)
  end

  def update
    payment.save!
    redirect_to payment_path(user)
  end

  def destroy
    payment.destroy
    redirect_to payment_path(user)
  end
end