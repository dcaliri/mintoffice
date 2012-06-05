class PaymentsController < ApplicationController
  expose(:users) { User(:protected) }
  expose(:user)
  expose(:payments) { user.payments }
  expose(:payment)

  def redirect_unless_permission
  end

  before_filter :redirect_unless_admin, :only => [:index, :new, :edit, :destroy, :create, :update]
  before_filter {|controller| controller.redirect_unless_me(user)}

  def index
    @from = Time.zone.now - 4.month
    @to = Time.zone.now + 3.month
    params[:with_no_payment] = params[:with_no_payment].to_bool

    if params[:with_no_payment]
      @hrinfos = Hrinfo
    else
      @hrinfos = Hrinfo.payment_in?(@from.to_date, @to.to_date)
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