module Reportable
  extend ActiveSupport::Concern

  def create_report
    report = build_report
    report.reporters << User.current_user.reporters.build(report_id: report, permission_type: "write", owner: true)
  end

  def create_accessor
    report.permission User.current_user, :write
  end

  delegate :access?, :to => :report
  delegate :report!, :approve!, :rollback!, :to => :report

  def redirect_when_reported
    self
  end

  module ClassMethods
    def access_list(user)
      joins(:report => :accessors).merge(AccessPerson.access_list(user))
    end

    def report_status(status)
      joins(:report => :reporters).merge(Report.search_by_status(status))
    end
  end

  included do
    has_one :report, as: :target
    before_create :create_report
    after_create :create_accessor

    extend ClassMethods
  end
end