module Reportable
  extend ActiveSupport::Concern

  def create_initial_report
    report = build_report
    report.reporters << User.current_user.reporters.build(report_id: report, owner: true)
  end

  def create_initial_accessor
    report.permission User.current_user, :write
  end

  def create_if_no_report
    if report.nil?
      report = create_report
      user = User.current_user
      if user.ingroup?(:admin)
        report.reporters << user.reporters.build(report_id: report, owner: true)
        report.permission user, :write
        report.save!
      end
    end
  end

  def localize_status
    report.localize_status rescue I18n.t("activerecord.attributes.report.localized_status.not_reported")
  end

  def access?(user, permission_type = :read)
    if report.present?
      report.access?(user, permission_type)
    else
      user.ingroup?(:admin)
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

    def access_list(user)
      includes(:report => :accessors).merge(AccessPerson.access_list(user))
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