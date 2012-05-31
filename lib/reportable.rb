module Reportable
  extend ActiveSupport::Concern

  def report
    if super == nil
      user = Group.where(name: "admin").first.users.first
      report = create_report
      report.permission user, :write
      report.reporters << user.reporters.build(report_id: report, owner: true)
      report.save!
    end
    super
  end
  alias_method :create_if_no_report, :report

  delegate :access?, :to => :report
  delegate :report!, :approve!, :rollback!, :to => :report

  def redirect_when_reported
    self
  end

  module ClassMethods
    def access_list(user)
      create_if_no_report
      joins(:report => :accessors).merge(AccessPerson.access_list(user))
    end

    def report_status(status)
      create_if_no_report
      joins(:report => :reporters).merge(Report.search_by_status(status))
    end
  end

  included do
    has_one :report, as: :target

    extend ClassMethods
  end
end