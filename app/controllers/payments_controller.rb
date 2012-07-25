class PaymentsController < ApplicationController
  expose(:accounts) { Account(:protected) }
  expose(:account)
  expose(:payments) { account.employee.payments }
  expose(:payment)

  def redirect_unless_permission
  end

  def another_account_cant_access_yearly
    force_redirect if !current_account.admin?
  end

  before_filter :redirect_unless_admin, :only => [:index, :new, :edit, :destroy, :create, :update]
  before_filter {|controller| controller.redirect_unless_me(account)}
  before_filter :another_account_cant_access_yearly, :except => [:show]

  def index
    @from = Time.zone.now - 4.month
    @to = Time.zone.now + 3.month
    params[:with_no_payment] = params[:with_no_payment].to_bool

    if params[:with_no_payment]
      @employees = Employee
    else
      @employees = Employee.payment_in?(@from.to_date, @to.to_date)
    end
    @employees = @employees.paginate(:page => params[:page], :per_page => 20)
    @payments = Payment
  end

  def create
    payment.save!
    redirect_to payment_path(account)
  end

  def create_yearly
    payments.create_yearly!(params[:payments])
    redirect_to payment_path(account)
  end

  def update
    payment.save!
    redirect_to payment_path(account)
  end

  def destroy
    payment.destroy
    redirect_to payment_path(account)
  end
end