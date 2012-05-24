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
    @from = Time.zone.now - 4.month
    @to = Time.zone.now + 3.month
    params[:by_payment] = params[:by_payment].to_bool

    if params[:by_payment]
      @hrinfos = Hrinfo.payment_in?(@from.to_date, @to.to_date)
    else
      @hrinfos = Hrinfo
    end
    @hrinfos = @hrinfos.paginate(:page => params[:page], :per_page => 20)
    @payments = Payment
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