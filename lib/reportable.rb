module Reportable
  extend ActiveSupport::Concern

  def create_report
    report = build_report
    report.reporter = User.current_user.hrinfo.reporters.build(report_id: report)
  end

  def access?(user)
    report.reporter.hrinfo.user == user
  end

  included do
    has_one :report, as: :target
    before_create :create_report
  end
end