# encoding: UTF-8

class PayrollsController < ApplicationController
  before_filter :find_period
  def redirect_unless_permission; end

  expose (:payroll)
  expose (:accounts) {Account(:protected).enabled}
  expose (:employees) {Employee.not_retired}

  def index
    @payrolls = Payroll.by_period(@period)
    @payrolls = @payrolls.by_employee(current_person.employee)
  end

  def create
    payroll.save!
    redirect_to [:payrolls]
  end

  def update
    payroll.save!
    redirect_to [:payroll]
  end

  def generate
    today = Date.today
    payday = today.change(day: params[:payday].to_i)
    Payment.generate_payrolls(payday)
    redirect_to :payrolls, notice: "성공적으로 급여대장을 생성하였습니다."
  end

  private
  def find_period
    @period = Date.parse(params[:period]) if params[:period].present?
  end
end