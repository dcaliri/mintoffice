module Reportable
  extend ActiveSupport::Concern

  def create_report
    report = build_report
    report.reporters << User.current_user.reporters.build(report_id: report, permission_type: "write", owner: true)
  end

  def create_accessor
    report.permission User.current_user, :write
  end

  def access?(user, permission_type = :read)
    report.access?(user, permission_type)
  end

  def report!(user, comment)
    report.report!(user, comment)
  end

  def approve!(comment)
    report.approve!(comment)
  end

  def rollback!(comment)
    report.rollback!(comment)
  end

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