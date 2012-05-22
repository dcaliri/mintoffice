module Reportable
  extend ActiveSupport::Concern

  def create_report
    report = build_report
    report.reporter = User.current_user.reporters.build(report_id: report)
  end

  def access?(user)
    report.access?(user)
  end

  module ClassMethods
    def access_list(user)
      joins(:report => :reporter).merge(ReportPerson.access_list(user))
    end
  end

  included do
    has_one :report, as: :target
    before_create :create_report

    extend ClassMethods
  end
end