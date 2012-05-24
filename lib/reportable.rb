module Reportable
  extend ActiveSupport::Concern

  def create_report
    report = build_report
    report.reporters << User.current_user.reporters.build(report_id: report, permission_type: "write")
  end

  def access?(user, permission_type = :read)
    report.access?(user, permission_type)
  end

  module ClassMethods
    def access_list(user)
      joins(:report => :reporters).merge(ReportPerson.access_list(user))
    end

    def report_status(status)
      joins(:report).merge(Report.search_by_status(status))
    end
  end

  included do
    has_one :report, as: :target
    before_create :create_report

    extend ClassMethods
  end
end