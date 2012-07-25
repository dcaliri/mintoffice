module Reportable
  extend ActiveSupport::Concern

  def create_initial_report
    report = build_report
    report.reporters << Account.current_account.person.reporters.build(report_id: report, owner: true)
  end

  def create_initial_accessor
    report.permission Account.current_account, :write
  end

  def create_if_no_report
    if report.nil?
      report = create_report
      account = Account.current_account
      if account.ingroup?(:admin)
        report.reporters << account.person.reporters.build(report_id: report, owner: true)
        report.permission account, :write
        report.save!
      end
    end
  end

  def localize_status
    if self.class == Employee
      I18n.t("activerecord.attributes.employee.localized_status.#{report.status}")
    else
      report.localize_status rescue I18n.t("activerecord.attributes.report.localized_status.not_reported")
    end
  end

  def access?(account, permission_type = :read)
    if report.present?
      report.access?(account, permission_type)
    else
      account.ingroup?(:admin)
    end
  end
  delegate :report!, :approve!, :rollback!, :to => :report

  def redirect_when_reported
    self
  end

  module ClassMethods
    def no_permission
      includes(:report => :accessors).merge(AccessPerson.no_permission)
    end

    def access_list(account)
      includes(:report => :accessors).merge(AccessPerson.access_list(account))
    end

    def report_status(status)
      includes(:report => :reporters).merge(Report.search_by_status(status))
    end
  end

  included do
    has_one :report, as: :target, dependent: :destroy
    before_create :create_initial_report, unless: :prevent_create_report
    after_create :create_initial_accessor, unless: :prevent_create_report

    attr_accessor :prevent_create_report
    extend ClassMethods
  end
end