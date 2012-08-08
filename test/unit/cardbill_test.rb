require 'test_helper'

class CardbillTest < ActiveSupport::TestCase
  fixtures :users
  fixtures :reports
  fixtures :report_people
  fixtures :report_comments
  fixtures :cardbills

  test "manager report to user" do
    User.current_user = users(:card_manager_account)

    prev_reporter = current_report.reporter
    prev_reporter.owner = false
    
    next_reporter = current_target_user.reporters.build(owner: true)
    next_reporter.prev = prev_reporter
    assert current_report.reporters << next_reporter

    current_report.status = :reporting
    assert current_report.comments.build(owner: prev_reporter, description: "#{next_reporter.fullname}"+I18n.t('models.report.to_report'))
    assert current_report.comments.build(owner: prev_reporter, description: "test")

    assert next_reporter.save!
    assert prev_reporter.save!

    target_name = current_cardbill.class.to_s.downcase
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

  test "user report to admin" do
    User.current_user = users(:card_user_account)

    prev_reporter = current_report.reporter
    prev_reporter.owner = false
    
    next_reporter = current_target_admin.reporters.build(owner: true)
    next_reporter.prev = prev_reporter
    assert current_report.reporters << next_reporter

    current_report.status = :reporting
    assert current_report.comments.build(owner: prev_reporter, description: "#{next_reporter.fullname}"+I18n.t('models.report.to_report'))
    assert current_report.comments.build(owner: prev_reporter, description: "test")

    assert next_reporter.save!
    assert prev_reporter.save!

    target_name = current_cardbill.class.to_s.downcase
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

  test "admin approve cardbill to user" do
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

  def current_manager
    @manager ||= users(:card_manager_account)
  end

  def current_target_user
    @target_user ||= users(:card_user_account)
  end

  def current_target_admin
    @target_admin ||= users(:admin_account)
  end

  def current_report
    @cardbill_report ||= reports(:cardbill_process_cardbill_fixture)
  end
end