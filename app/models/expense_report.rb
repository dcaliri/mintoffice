# encoding: UTF-8

class ExpenseReport < ActiveRecord::Base
  belongs_to :employee
  belongs_to :target, polymorphic: true
  belongs_to :project

  has_one :posting

  by_star_field :expensed_at

  include Reportable
  include Taggable

  before_validation :check_total_amount
  def check_total_amount
    except_me = target.expense_reports.where('id IS NOT ?', id)
    if except_me.total_amount + self.amount > target.totalamount
      errors.add(:amount, "이 너무 많습니다")
    end
  end

  def summary
    username = report.reporter.prev.fullname rescue ""
    "[지출내역서] #{username} 소유자: #{employee.fullname} 프로젝트: #{project.name} 사유: #{description}, 금액: #{ActionController::Base.helpers.number_to_currency(amount)}"
  end

  def add_permission_of_project_owner
    report.permission project.owner.person, :write if project and project.owner
  end

  def make_posting
    build_posting(posted_at: expensed_at).tap do |posting|
      posting.items.build(item_type: I18n.t('models.expense_report.debit'), amount: amount)
      posting.items.build(item_type: I18n.t('models.expense_report.credit'), amount: amount)
    end
  end

  def report!(person, comment, report_url)
    if target_type == "Cardbill"
      target.report.permission person, :read
    end
    super
  end

  def approve?(person)
    (project and project.owner and project.owner.person == person) or super
  end

  def access?(person, access_type = :read)
    return false if access_type == :write and posting
    super
  end

  class << self
    def filter(params)
      result = by_project(params[:project]).by_period(params[:year], params[:month])
      result = if params[:empty_permission] == 'true'
                result.no_permission
              else
                result.access_list(params[:person])
              end
      result
    end

    def by_project(project)
      where(project ? {project_id: project.id} : {})
    end

    def by_period(year, month)
      if year and year > 0
        if month and month > 0
          by_month(month, :year => year)
        else
          by_year(year)
        end
      else
        if month and month > 0
          by_month(month)
        else
          where("")
        end
      end
    end

    def oldest_year
      order('expensed_at ASC').first.expensed_at.year rescue Date.today.year
    end

    def newest_year
      order('expensed_at DESC').first.expensed_at.year rescue Date.today.year
    end

    def total_amount
      sum{|report| report.amount}
    end
  end

end