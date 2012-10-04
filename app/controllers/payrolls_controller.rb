# encoding: UTF-8

class PayrollsController < ApplicationController
  before_filter :find_period
  before_filter :redirect_unless_me, except: [:index, :generate, :generate_payment_request, :generate_form]
  def redirect_unless_permission; end

  expose (:payroll)
  expose (:accounts) {Account(:protected).enabled}
  expose (:employees) {Employee.not_retired}

  def index
    @payrolls = Payroll.by_period(@period)
    @payrolls = @payrolls.by_employee(current_person.employee) unless current_person.admin?
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

  def generate_payment_request
    @payrolls = Payroll.by_period(@period)
    @no_bankbook_employees = @payrolls.no_bankbook

    if @no_bankbook_employees.empty?
      @payrolls.generate_payment_request
      redirect_to :back, notice: "성공적으로 지급 청구를 생성하였습니다."
    else
      employess = @no_bankbook_employees.map{|employee| employee.fullname}.join(', ')
      message = "#{employess}들의 통장 정보가 없습니다."
      redirect_to :back, alert: message
    end
  end

  private
  def find_period
    @period = Date.parse(params[:period]) if params[:period].present?
  end

  def redirect_unless_me
    unless current_person.admin? or payroll.employee.person == current_person
      force_redirect
    end
  end
end