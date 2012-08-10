require 'test_helper'

class ExpenseReportTest < ActiveSupport::TestCase
  fixtures :cardbills
  fixtures :projects
  fixtures :expense_reports
  fixtures :reports
  fixtures :report_people
  fixtures :report_comments

  def setup
    User.current_user = users(:card_user_account)
  end

  test "user create expense_report" do
    expense_report = ExpenseReport.new

    expense_report.hrinfo_id = current_target_user_hrinfos.id
    expense_report.target_type = current_cardbill.class
    expense_report.target_id = current_cardbill.id
    expense_report.project_id = current_project.id
    expense_report.description = "test"
    expense_report.expensed_at = current_cardbill.transdate
    expense_report.amount = current_cardbill.totalamount

    assert expense_report.save!
  end

  test "user report to admin" do
    prev_reporter = current_report.reporter
    prev_reporter.owner = false

    
    next_reporter = current_admin.reporters.build(owner: true)
    next_reporter.prev = prev_reporter
    assert current_report.reporters << next_reporter
    

    current_report.status = :reporting
    assert current_report.comments.build(owner: prev_reporter, description: "#{next_reporter.fullname}"+I18n.t('models.report.to_report'))
    assert current_report.comments.build(owner: prev_reporter, description: "test")

    assert next_reporter.save!
    assert prev_reporter.save!

    target_name = current_expense_report.class.to_s.downcase
    title = I18n.t("reports.report.title.#{target_name}", {
      default: I18n.t("reports.report.title.default"),
      prev: prev_reporter.fullname,
      next: next_reporter.fullname
    })

    body = I18n.t("reports.report.body.#{target_name}", {
      default: I18n.t("reports.report.body.default"),
      prev: prev_reporter.fullname,
      next: next_reporter.fullname,
      url: '/'
    })

    assert current_report.save!
  end

  test "admin approve expense_report to user" do
    User.current_user = users(:admin_account)

    prev_reporter = current_report.reporter

    current_report.status = :reported
    User.current_user.reporters.create!(report_id: id, owner: true) unless current_report.reporter
    assert current_report.comments.build(owner: prev_reporter, description: "#{prev_reporter.fullname}"+I18n.t('models.report.to_approve'))
    assert current_report.comments.build(owner: prev_reporter, description: "test")
    assert current_report.save!
  end

  private
  def current_cardbill
    @cardbill ||= cardbills(:has_permission_cardbill)
  end

  def current_admin
    @target_user ||= users(:admin_account)
  end

  def current_target_user_hrinfos
    @hrinfo ||= hrinfos(:card_used_user)
  end

  def current_project
    @project ||= projects(:fixture)
  end

  def current_expense_report
    @expense_report ||= expense_reports(:user_expense_report)
  end

  def current_report
    @report ||= reports(:cardbill_process_expense_report_cardbill)
  end
end