class PaymentsController < ApplicationController
  before_filter :redirect_unless_me, :only => :show

  expose(:users) { User(:protected) }
  expose(:user)
  expose(:payments) { user.payments }
  expose(:payment)

  def redirect_unless_permission
  end

  before_filter :redirect_unless_me, :only => :show

  def redirect_unless_me
    unless @user.ingroup?(:admin)
      force_redirect if @user.id != params[:id].to_i
    end
  end

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