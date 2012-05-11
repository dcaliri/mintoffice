class PaymentsController < ApplicationController
  expose(:users) { User(:protected) }
  expose(:user)
  expose(:payments) { user.payments }
  expose(:payment)

  def redirect_unless_permission
  end

  before_filter :redirect_unless_admin, :only => :index
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

  def calculate
    @pay_start = DateTime.parse_by_params(params[:payments], :pay_start).to_time
    @pay_end = DateTime.parse_by_params(params[:payments], :pay_end).to_time
    @period = ((@pay_end - @pay_start) / 1.month).to_s.to_i
  end

  def create_new_yearly
    payments.create_new_yearly!(params[:payments])
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